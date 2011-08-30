source :rubygems

# Use this line instead if you want to bundle from a local copy.
# gem "jenkins-plugin-runtime", :path => "#{File.dirname(__FILE__)}/../jenkins-plugin-runtime"
gem "jenkins-plugin-runtime", :git => "https://github.com/cowboyd/jenkins-plugin-runtime.git"

group :development do
  # we need this patched version of bundler in order to generate valide .hpi file
  gem "bundler", :git => "https://github.com/cowboyd/bundler.git"
  gem "jenkins-plugin", :git => "https://github.com/cowboyd/jenkins-plugin.git"
end
