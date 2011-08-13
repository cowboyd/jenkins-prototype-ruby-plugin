
# First, let's declare some metadata about the plugin that might be needed. These are properties
# I just pulled out of the air. The point is, let's put everything as constants here, and then maybe we can
# move all the metadata eventually into a `Pluginfile` or a `ruby-prototype.pluginspec` that can be eval'd
# separately

PluginName = 'ruby-prototype'
PluginVersion = '0.1.0'
PluginJenkinsVersion = ">= 1.410"
PluginDeps = []

require 'jenkins/rake'
Jenkins::Rake.install_tasks

desc "run a Jenkins server with this plugin"
task :server do
  #do stuff to generate a valid .hpl
  # this might involve compiling some custome java classes, generating manifests, etc.
end
