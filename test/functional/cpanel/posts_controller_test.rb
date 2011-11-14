require 'test_helper'

class Cpanel::PostsControllerTest < ActionController::TestCase
  test "should get post index" do
    Factory :post
    Factory :post, :state => :approved
    Factory :post, :state => :rejected
    sign_in Factory(:admin)
    get :index
    assert_response :success, @response.body
  end
end
