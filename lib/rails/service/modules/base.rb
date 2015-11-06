module Rails
  module Service
    module Modules
      class Base
        # TODO: rename to module name
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

        # TODO: Rename it to `module_object` maybe?
        def to_module
          nil
        end
      end
    end
  end
end
