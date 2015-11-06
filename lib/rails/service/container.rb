require 'rails/service/modules/base'
require 'rails/service/dependency_graph'

module Rails
  module Service
    class Container
      attr_accessor :modules, :modules_resolved

      def initialize(opts = {})
        @app = opts.delete(:app)

        @graph = DependencyGraph.new
        @resolved_graph = []

        @modules_enabled = opts.delete(:modules)
        @modules = {}
      end

      # Runs a container
      def run!
        init
        start
        at_exit { stop }
      end

      private

      def init
        load_modules
        resolve_dependencies
        init_modules

        modules_call(:init)
      end

      def start
        modules_call(:start)
      end

      def stop
        modules_call(:stop)
      end

      def modules_call(method)
        @modules.each do |name, module_object|
          if module_object.respond_to?(method.to_sym)
            if method == :init
              module_init(name, module_object)
            else
              module_object.send(method)
            end
          end
        end
      end

      def module_init(name, module_object)
        arity = module_object.method(:init).arity
        module_deps = module_object.class._dependencies

        raise ArgumentError, "Module #{module_object} have #{module_deps.length} and #init takes #{arity} args" if arity < -1 && module_deps.length != arity

        module_deps_objects = @modules.values_at(*module_deps).map(&:to_module)
        module_object.init(*module_deps_objects)
      end

      def load_modules
        modules = {}
        Rails::Service::Modules::Base.subclasses.each do |klass|
          name = resolve_module_name(klass)
          # TODO: Add error msg
          raise NameError if modules.key?(name)
          modules[name] = klass
        end

        # Pick only modules that are enabled
        @modules = modules.slice!(@modules_enabled)
      end

      def resolve_module_name(klass)
        (klass._name || klass.to_s.demodulize.underscore).to_sym
      end

      # TODO: Add logging
      def resolve_dependencies
        @modules.map do |name, klass|
          klass._dependencies.each do |dep|
            @graph.add_edge(name, dep)
          end
        end
        @resolved_graph = @graph.resolve
      end

      def init_modules
        @modules = Hash[@modules.map { |name, klass| [name, klass.new] }]
      end
    end
  end
end
