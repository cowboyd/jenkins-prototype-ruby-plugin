# TODO: move to jenkins-plugin-runtime
module Jenkins
  module Tasks
    # TODO: let Builder include it
    module BuildStep
      ##
      # Runs before the build begins
      #
      # @param [Jenkins::Model::Build] build the build which will begin
      # @param [Jenkins::Launcher] launcher the launcher that can run code on the node running this build      
      # @param [Jenkins::Model::Listener] listener the listener for this build.
      def prebuild(build, launcher, listener)
      end 
        
      ##
      # Runs the step over the given build and reports the progress to the listener.
      # 
      # @param [Jenkins::Model::Build] build on which to run this step
      # @param [Jenkins::Launcher] launcher the launcher that can run code on the node running this build
      # @param [Jenkins::Model::Listener] listener the listener for this build.
      def perform(build, launcher, listener)
      end
    end

    class Publisher
      include Jenkins::Model
      include Jenkins::Model::Describable

      include BuildStep

      describe_as Java.hudson.tasks.Publisher
    end
  end

  class Plugin
    class Proxies
      # TODO: let Builder include it
      module BuildStep
        def prebuild(build, listener)
          boolean_result(listener) do
            @object.prebuild(import(build), import(listener))
          end
        end

        def perform(build, launcher, listener)
          boolean_result(listener) do
            @object.perform(import(build), import(launcher), import(listener))
          end
        end

      private

        def boolean_result(listener, &block)
          begin
            yield
            true
          rescue Exception => e
            msg = "#{e.message} (#{e.class})\n" << (e.backtrace || []).join("\n")
            listener.error(msg + "\n")
            false
          end
        end
      end

      class Publisher < Java.hudson.tasks.Publisher
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

      register Jenkins::Tasks::Publisher, Publisher
    end
  end
end

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
