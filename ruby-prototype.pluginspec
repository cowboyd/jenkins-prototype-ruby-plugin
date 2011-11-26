
Jenkins::Plugin::Specification.new do |plugin|
  plugin.name = 'ruby-prototype'
  plugin.version = '0.1.0'
  plugin.description = 'a pure ruby playground for Jenkins plugins'
  plugin.url = 'https://github.com/cowboyd/jenkins-prototype-ruby-plugin'

  plugin.depends_on 'ruby-runtime', '0.3'
end
