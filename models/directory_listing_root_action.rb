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

dir = DirectoryListingRootAction.new(File.expand_path('..', File.dirname(__FILE__)))
Jenkins::Plugin.instance.register_extension(dir)
