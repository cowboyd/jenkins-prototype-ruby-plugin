class TestBuilder < Jenkins::Tasks::Builder

  display_name "Test Builder"

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
    # TODO: why stdout(listener) raises '(ArgumentError) wrong number of arguments (1 for 0)' ?
    # TODO: listner must be 'export(listener)'
    launcher.launch.pwd("/").cmds("echo", "Hello", "World").start().stdout(listener)
    true
  end
end
