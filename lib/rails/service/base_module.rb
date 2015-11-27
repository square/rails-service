module Rails
  module Service
    class BaseModule
      # TODO: rename to module name
      def self.name(name)
        @name = name
      end

      def self._name
        @name || self.to_s.demodulize.downcase.to_sym
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

      attr_reader :app

      def initialize(app)
        @app = app
      end

      # TODO: Rename it to `module_object` maybe?
      def to_module
        nil
      end
    end
  end
end
