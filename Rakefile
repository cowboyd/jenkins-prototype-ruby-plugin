
load "#{File.dirname(__FILE__)}/.rake" if File.exists? '.rake'

require 'jenkins/rake'
Jenkins::Rake.install_tasks


task :foo,:x do |t,args|
  puts "ARGS: #{args.inspect}"
end


desc "create a sample .rake file that allows you to provide environment overrides"
task :rakedev do
  fail ".rake already exists" if File.exists?(".rake")
  File.open(".rake", "w") do |f|
    f.write<<-RAKE
puts "Using devmods in #{__FILE__}"
#override paths, environment, etc....
#require 'pathname'
#$:.unshift Pathname(__FILE__).dirname.join('../jenkins-plugin-tools/lib').expand_path
RAKE
  end
end
