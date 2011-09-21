class ModelReloadRootAction < Jenkins::Model::RootAction
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

reload = ModelReloadAction.new
Jenkins::Plugin.instance.register_extension(reload)
