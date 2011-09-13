# TODO: Move to jenkins-plugin-runtime
module Jenkins
  class Plugin
    class Proxies
      class RootAction
        include Java.hudson.model.RootAction
        include Jenkins::Plugin::Proxy

        def getDisplayName
          @object.display_name
        end

        def getIconFileName
          @object.icon
        end

        def getUrlName
          @object.url_path
        end
      end

      register Jenkins::Model::RootAction, RootAction
    end
  end
end

# Plugin part

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

class ModelReloadAction < Jenkins::Model::RootAction
  display_name 'Reload Ruby plugins'
  icon 'refresh.png'
  url_path 'reload_ruby_plugins'

  # TODO: no need to be a RackApp
  include Jenkins::RackSupport
  def call(env)
    # TODO: add to Jenkins::Plugin
    Jenkins::Plugin.instance.instance_eval do
      @peer.getExtensions().clear
    end
    Jenkins::Plugin.instance.load_models
    # TODO: is it enough for Jenkins/JRuby plugin for reloading?
    Sinatra.new(Sinatra::Base) {
      get('/') { redirect '/' }
    }.call(env)
  end
end

require 'webrick'
require 'logger'
class DirectoryListingRootAction < Jenkins::Model::RootAction
  display_name 'Directory Listing'
  icon 'folder.png'
  url_path 'dir'

  def initialize(root = File.dirname(__FILE__))
    @logger = Logger.new(STDERR)
    @config = {
      :HTTPVersion => '1.1',
      :Logger => @logger,
      :DirectoryIndex => ['index.html'],
      :MimeTypes => WEBrick::HTTPUtils::DefaultMimeTypes,
    }
    server = Struct.new(:config).new
    server.config = @config
    @servlet = WEBrick::HTTPServlet::FileHandler.new(server, root, :FancyIndexing => true)
  end

  include Java.jenkins.ruby.DoDynamic
  def doDynamic(request, response)
    begin
      req = WEBrick::HTTPRequest.new(@config)
      req.path_info = request.getRestOfPath() + "/"
      req.script_name = ""
      req.instance_variable_set("@path", request.getRestOfPath() + "/")
      req.instance_variable_set("@request_method", 'GET')
      res = WEBrick::HTTPResponse.new(@config)
      @servlet.do_GET(req, res)
      res.send_body(str = '')
      response.getWriter().print(str)
    rescue Exception => e
      @logger.error(e)
    end
  end
end

# TODO: manual registration looks uglish but it would be more flexible than auto registration. 
test = TestRootAction
reload = ModelReloadAction.new
dir = DirectoryListingRootAction.new(File.expand_path('..', File.dirname(__FILE__)))
Jenkins::Plugin.instance.register_extension(test)
Jenkins::Plugin.instance.register_extension(reload)
Jenkins::Plugin.instance.register_extension(dir)
