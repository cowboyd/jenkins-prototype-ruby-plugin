require 'jenkins/tasks/build_step'

module Jenkins
  module Tasks
    class Notifier
      include Jenkins::Model
      include Jenkins::Model::Describable

      include BuildStep

      describe_as Java.hudson.tasks.Notifier
    end

    class Recorder
      include Jenkins::Model
      include Jenkins::Model::Describable

      include BuildStep

      describe_as Java.hudson.tasks.Recorder
    end
  end
end

require 'jenkins/plugin/proxies/build_step'

module Jenkins
  class Plugin
    class Proxies
      class Notifier < Java.hudson.tasks.Notifier
        include Java.jenkins.ruby.Get
        include Jenkins::Plugin::Proxy

        include BuildStep

        def getDescriptor
          @plugin.descriptors[@object.class]
        end

        def get(name)
          @object.respond_to?(name) ? @object.send(name) : nil
        end
      end

      register Jenkins::Tasks::Notifier, Notifier

      class Recorder < Java.hudson.tasks.Recorder
        include Java.jenkins.ruby.Get
        include Jenkins::Plugin::Proxy

        include BuildStep

        def getDescriptor
          @plugin.descriptors[@object.class]
        end

        def get(name)
          @object.respond_to?(name) ? @object.send(name) : nil
        end
      end

      register Jenkins::Tasks::Recorder, Recorder
    end
  end
end

class TestNotifier < Jenkins::Tasks::Notifier
  display_name "Test Notifier"

  def prebuild(build, listener)
    listener.info "Notifier#prebuild"
  end

  def perform(build, launcher, listener)
    listener.info "Notifier#perform"
  end
end

class TestRecorder < Jenkins::Tasks::Recorder
  display_name "Test Recorder"

  def prebuild(build, listener)
    listener.info "Recorder#prebuild"
  end

  def perform(build, launcher, listener)
    listener.info "Recorder#perform"
  end
end
