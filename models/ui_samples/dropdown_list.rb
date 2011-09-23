module UISamples

  # WARNING: This port is incomplete you'll see empty dropdown list now.
  # See TODO's below.
  class DropdownList < BaseAction
    description "[NOT YET] Show different form elements based on choice in a &lt;select> control"

    def fruit
      nil
    end

    # TODO: It doesn't work. We need to handle right descriptors here for (st:include page) in view.
    def fruit_descriptors
      [Apple.new, Banana.new]
    end

    class Fruit < Action
#      include Jenkins::Model
#      include Jenkins::Model::Describable

      # TODO: Should create Java side Descriptor class and use Descriptor#getConfigPage. Is it worth trying?
      def config_page
        "/#{name_to_path}/config"
      end

      def self.display_name(name = nil)
        @display_name = name if name
        @display_name
      end

      def display_name
        self.class.display_name
      end

      def name_to_path
        self.class.name.split('::').join('/')
      end
    end

    class Apple < Fruit
      display_name "Apple"
    end

    class Banana < Fruit
      display_name "Banana"
    end
  end
end

Jenkins::Plugin.instance.register_extension(UISamples::DropdownList)
