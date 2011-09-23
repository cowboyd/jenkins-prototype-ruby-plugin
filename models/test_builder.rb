=begin
class TestBuilder < Jenkins::Tasks::Builder

  display_name "Test Builder"

  def initialize(attrs)
    p attrs
  end

  def prebuild(build, listener)
    listener.log "= build_var\n"
    log_hash(listener, build.build_var)
    listener.log "= env\n"
    log_hash(listener, build.env)
    true
  end

  def log_hash(listener, hash)
    hash.each do |k, v|
      listener.log [k, ": ", v, "\n"].join
    end
  end

  def perform(build, launcher, listener)
    listener.log "perform\n"
    # TODO: Uglish. See TODO in jenkins-plugin-runtime
    starter = launcher.launch.
      pwd("/").
      cmds("ls", "-l").
      stdout(Jenkins::Plugin.instance.export(listener))
    starter.join()
    true
  end
end
=end
