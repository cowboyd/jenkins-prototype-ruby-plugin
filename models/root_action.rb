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

        # TODO: is it OK to use snake_case?
        def display_name
          @object.display_name
        end

        def icon_file_name
          @object.icon
        end

        def url_name
          @object.url_name
        end

        def descriptor
          @plugin.descriptors[@object.class]
        end
      end

      register Jenkins::Actions::RootAction, RootAction
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
