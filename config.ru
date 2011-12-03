# This file is used by Rack-based servers to start the application.
app_start_init_time = Time.now

require ::File.expand_path('../config/environment',  __FILE__)

app_init_finish_time = Time.now
if ENV["SHOW_BOOT_TIME"] || Rails.env.development?
  puts "=> boot app used #{app_init_finish_time - app_start_init_time} seconds"
end

map "/assets" do
  use Rack::Lock
  run Rails.application.assets
end

map "/" do
  run RubyChina::Application
end
