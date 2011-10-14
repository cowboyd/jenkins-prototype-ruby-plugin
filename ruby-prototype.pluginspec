
Jenkins::Plugin::Specification.new do |plugin|
  plugin.name = 'ruby-prototype'
  plugin.version = '0.1.0'
  plugin.description = 'a pure ruby playground for Jenkins plugins'

  plugin.depends_on 'ruby-runtime', '0.3'
end
