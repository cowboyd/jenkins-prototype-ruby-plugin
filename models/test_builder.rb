=begin
class TestBuilder < Jenkins::Tasks::Builder

  display_name "Test Builder"

  def initialize(attrs)
    p attrs
  end

  def prebuild(build, listener)
    listener.info "= build_var"
    log_hash(listener, build.build_var)
    listener.info "= env"
    log_hash(listener, build.env)
  end

  def log_hash(listener, hash)
    hash.each do |k, v|
      listener.info [k, ": ", v].join
    end
  end

  def perform(build, launcher, listener)
    listener.info "perform"
    launcher.execute("ls -l", :chdir => "/", :out => listener)
  end
end
=end
