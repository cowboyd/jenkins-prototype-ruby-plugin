# we are supposed to be auto-discovering this
Jenkins::Model::Descriptor.new("noop_wrapper", LoggingWrapper, self, Java.hudson.tasks.BuildWrapper.java_class).tap do |d|
  @java.addExtension(d)
  @descriptors[LoggingWrapper] = d
end

Jenkins::Model::Descriptor.new("test_root_action", TestRootAction, self, Java.hudson.model.RootAction.java_class).tap do |d|
  @java.addExtension(d)
  @descriptors[TestRootAction] = d
end

TestRootAction.new.tap do |action|
  @java.addExtension(export(action))
end
