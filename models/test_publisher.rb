class TestPublisher < Jenkins::Tasks::Publisher
  display_name "Test Publisher"

  def initialize(attrs)
    p attrs
  end

  def prebuild(build, listener)
    listener.info {
      "Test Publisher#prebuild"
    }
  end

  def perform(build, launcher, listener)
    listener.error {
      "Test Publisher#perform"
    }
  end
end
