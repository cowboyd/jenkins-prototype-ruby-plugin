require 'sinatra/base'
require 'jenkins/rack'
class SomeSinatraApp < Sinatra::Base
  get '/hi' do
    'Hello world from Sinatra!'
  end
end

class TestRootAction < Jenkins::Model::RootAction
  display_name 'Test Root Action'
  icon 'gear.png'
  url_path 'root_action'

  # this part shows how to mount Rack app to take over the request handling entirely
  # to see this in action request "/root_action/hi" in your browser
  include Jenkins::RackSupport
  def call(env)
    SomeSinatraApp.new.call(env)
  end
end

Jenkins::Plugin.instance.register_extension(TestRootAction)
