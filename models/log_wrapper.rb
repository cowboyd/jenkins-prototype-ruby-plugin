
##
# Output a message to the console when the build is to start
# and when it has ended.
class LoggingWrapper < Jenkins::Tasks::BuildWrapper

  display_name "Logging Build Wrapper"

  # Called some time before the build is to start.
  def setup(build, launcher, listener, env)
    listener.log "build will start\n"
    return true
  end

  # Called some time when the build is finished.
  def teardown(build, listener, env)
    listener.log "build finished\n"
    return true
  end
end
