# we are supposed to be auto-discovering this
Jenkins::Model::Descriptor.new("noop_wrapper", LoggingWrapper, self, Java::hudson.tasks.BuildWrapper.java_class).tap do |d|
  @java.addExtension(d)
  @descriptors[LoggingWrapper] = d
end
