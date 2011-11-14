# coding: utf-8
class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::SoftDelete
  include Mongoid::BaseModel
  include Redis::Search
  include Redis::Objects
  
  state_machine :state, :initial => :pending do
    event :approve do
      transition :pending => :approved
    end
    event :reject do
      transition all => :rejected
    end
  end
  
  field :title, :type => String
  field :body, :type => String
  field :tags, :type => Array, :default => []
  # 来源名称
  field :source
  # 来源地址
  field :source_url
  field :comments_count, :type => Integer, :default => 0
  belongs_to :user
  
  index :tags
  index :user_id
  index :state
  index [:tags, :state]
  
  counter :hits, :default => 0
  
  attr_protected :state, :user_id
  attr_accessor :tag_list
  
  validates_presence_of :title, :body, :tag_list
  
  scope :normal, where(:state => :approved)
  scope :by_tag, Proc.new { |t| where(:tags => t) }
  
  before_save :split_tags
  def split_tags
    if !self.tag_list.blank? and self.tags.blank?
      self.tags = self.tag_list.split(/,|，/).collect { |tag| tag.strip }.uniq
    end
  end

  def self.state_collection
    state_machine.states.map{|state| [human_attribute_name(state.name), state.name]}
  end
end
