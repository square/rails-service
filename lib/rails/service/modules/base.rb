module Rails
  module Service
    module Modules
      class Base
        def self.name(name)
          @name = name
        end

        def self._name
          @name
        end

        # Add a options hash to disable auto-creating attr's
        # (eg `dependencies :config, :logger, create_attr: false`)
        def self.dependencies(*args)
          @dependencies = args
          args.each { |arg| attr_accessor(arg.to_sym) }
        end

        def self._dependencies
          @dependencies || []
        end

        def initialize(*); end

        def to_module
          nil
        end
      end
    end
  end
end
