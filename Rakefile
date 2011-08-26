
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

# TODO: to be moved to ruby-plugin-tools later
# but experimenting here first for rapid development cycle
desc "Directory used as JENKINS_HOME during 'rake server'"
directory work = "work"

desc "run a Jenkins server with this plugin"
task :server => [:bundle, work] do
  require 'jenkins/war'
  require 'zip/zip'
  require 'fileutils'

  # generate the plugin manifest
  FileUtils.mkdir_p("#{work}/plugins")
  File.open("#{work}/plugins/#{::PluginName}.hpl",mode="w+") do |f|
    f.puts "Manifest-Version: 1.0"
    f.puts "Created-By: #{Jenkins::Plugin::Tools::VERSION}"
    f.puts "Build-Ruby-Platform: #{RUBY_PLATFORM}"
    f.puts "Build-Ruby-Version: #{RUBY_VERSION}"

    f.puts "Group-Id: org.jenkins-ci.plugins"
    f.puts "Short-Name: #{::PluginName}"
    f.puts "Long-Name: #{::PluginName}"     # TODO: better name
    f.puts "Url: http://jenkins-ci.org/"    # TODO: better value
    # f.puts "Compatible-Since-Version:"
    f.puts "Plugin-Class: ruby.RubyPlugin"
    f.puts "Plugin-Version: #{::PluginVersion}"
    f.puts "Jenkins-Version: 1.426"
    f.puts "Plugin-Dependencies: ruby-runtime:0.1-SNAPSHOT"
    # f.puts "Plugin-Developers:"
    f.puts "Libraries: "+["lib","models","pkg/vendor"].collect{|r| Dir.pwd+'/'+r}.join(",")
    # TODO: where do we put views?
    # TODO: where do we put static resources?
    f.puts "Resource-Path: #{Dir.pwd}/views"
  end

  # TODO: assembly dependency plugins

  # execute Jenkins
  args = []
  args << "java"
  args << "-DJENKINS_HOME=#{work}"
  args << "-jar"
  args << Jenkins::War::LOCATION
  exec *args
end
