module UISamples

  class Root < Jenkins::Model::RootAction
    icon 'gear.gif'
    display_name 'UI Samples (Ruby)'
    url_path 'ui-samples-ruby'

    include Java.jenkins.ruby.GetDynamic
    def getDynamic(name, req, res)
      all.find { |action| action.url_path == name }
    end

    def all
      BaseAction.all
    end
  end

  class BaseAction < Jenkins::Model::Action
    icon 'gear.gif'

    module Inherited
      def inherited(cls)
        cls.extend(ClassMethods)
        cls.send(:include, InstanceMethods)
        cls.class_eval do
          display_name simple_name
          url_path path_name
        end
      end
    end
    extend Inherited

    module ClassMethods
      def new(*arg)
        obj = allocate
        obj.send(:initialize, *arg)
        BaseAction.all << obj
        obj
      end

      def display_name(name = nil)
        @display_name = name if name
        @display_name
      end

      def description(desc = nil)
        @description = desc if desc
        @description
      end
    end

    module InstanceMethods
      def display_name
        self.class.display_name
      end

      def description
        self.class.description
      end
    end

    class << self
      def all
        @all ||= []
      end

      def simple_name
        self.name.sub(/\A.*::/, '')
      end

      def path_name
        underscore(simple_name)
      end

    private

      def underscore(word)
        word = word.to_s.dup
        word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
        word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
        word.tr!("-", "_")
        word.downcase!
        word
      end
    end
    # TODO: for reloading. Caching instances is a memory leak. We should find another way.
    all.clear

    # TODO: sample.jelly does not pick up 'it' correctly now.
    def sourceFiles
      [SourceFile.new(path_name + '.rb'), SourceFile.new(path_name + "/index.erb")]
    end
  end

  class SourceFile
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def resolve
      @name # TODO: need URL
    end

    def content
      # TODO
    end
  end
end

Jenkins::Plugin.instance.register_extension(UISamples::Root)
