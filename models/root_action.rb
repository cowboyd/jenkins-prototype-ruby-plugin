# Ad-hoc extension for jenkins-plugin-runtime
# TODO: Move to jenkins-plugin-runtime
module Jenkins
  module Actions
    class RootAction
      include Jenkins::Model::Action

      # TODO: Move to Jenkins::Model::Action?
      def url_name
        self.class.name
      end
    end
  end
end

module Jenkins
  class Plugin
    class Proxies
      class RootAction
        include Java.hudson.model.RootAction
        include Jenkins::Plugin::Proxy

        def displayName
          @object.display_name
        end

        def iconFileName
          @object.icon
        end

        def urlName
          @object.url_name
        end

        def getDescriptor
          @plugin.descriptors[@object.class]
        end
      end

      register Jenkins::Actions::RootAction, RootAction
    end
  end
end

module Jenkins
  class Plugin
    # TODO: how many other extension points other than RootAction?
    def register_root_action(action)
      @peer.addExtension(export(action))
    end
  end
end

# Plugin part
class TestRootAction < Jenkins::Actions::RootAction
  display_name "Test Root Action"

  def icon
    "gear.png"
  end

  # TODO: handle /erb/ (not yet)
  def url_name
    "erb"
  end
end

# TODO: manual registration looks uglish but it would be more flexible than auto registration. 
action = TestRootAction.new
Jenkins::Plugin.instance.register_root_action(action)
