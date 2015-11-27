require 'active_support/core_ext/class/subclasses'

require 'rails/service/base_module'
require 'rails/service/dependency_graph'

module Rails
  module Service
    class Container
      attr_accessor :modules_resolved

      def initialize(opts = {})
        @app = opts.delete(:app)

        @graph = DependencyGraph.new
        @resolved_graph = []

        @enabled = opts.delete(:modules)

        @modules_resolved = {}
        @modules_enabled = {}
        @modules_defined = {}
      end

      # Runs a container
      def run!(app)
        init(app)
        start
        at_exit { stop }
      end

      private

      def init(app)
        load_defined_modules
        resolve_dependencies
        init_modules(app)

        modules_call(:init)
      end

      def start
        modules_call(:start)
      end

      def stop
        modules_call(:stop)
      end

      # TODO: Add exception handling when calling module's methods
      def modules_call(method)
        @modules_resolved.each do |name, module_object|
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

        module_deps_objects = @modules_resolved.values_at(*module_deps).map(&:to_module)
        module_object.init(*module_deps_objects)
      end

      # TODO: check if all @enabled modules are defined and raise error if not.
      def load_defined_modules
        Rails::Service::BaseModule.subclasses.each do |klass|
          name = klass._name
          raise NameError, "Ambigious module names - #{name}" if @modules_defined.key?(name)
          @modules_defined[name] = klass
        end
        @modules_enabled = @modules_defined.slice(*@enabled)

        @defined_modules
      end

      # TODO: We should optimize it. Instead of resolving whole graph,
      # resolve graph of modules that are *enabled*
      # TODO: Standalone modules are lacking tests!
      def resolve_dependencies
        # Keeps track of modules without dependecies
        standalone = []
        @modules_enabled.each do |name, klass|
          if klass._dependencies.empty?
            standalone << name
          else
            klass._dependencies.each do |dep|
              @graph.add_edge(name, dep)
            end
          end
        end
        # NB: We to avoid duplication we call #uniq since some modules
        # can be standalone (no deps) but be a dependency of other module
        # so they'll end up in both arrays.
        @modules_resolved = (@graph.resolve + standalone).uniq
      end

      def init_modules(app)
        @modules_resolved = Hash[@modules_resolved.map { |name| [name, init_module_klass(name).new(app)] }]
      end

      def init_module_klass(name)
        raise ArgumentError, "Module #{name} undefined" unless @modules_defined.key?(name)
        @modules_defined.fetch(name)
      end
    end
  end
end
