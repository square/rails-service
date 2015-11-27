require 'active_support/core_ext/class/subclasses'

require 'rails/service/modules/base'
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

      def load_defined_modules
        Rails::Service::Modules::Base.subclasses.each do |klass|
          name = resolve_module_name(klass)
          raise NameError, "Ambigious module names - #{name}" if @modules_defined.key?(name)
          @modules_defined[name] = klass
        end
        @modules_enabled = @modules_defined.slice(*@enabled)

        @defined_modules
      end

      def resolve_module_name(klass)
        (klass._name || klass.to_s.demodulize.underscore).to_sym
      end

      # TODO: We should optimize it. Instead of resolving whole graph,
      # resolve graph of modules that are *enabled*
      def resolve_dependencies
        @modules_enabled.each do |name, klass|
          klass._dependencies.each do |dep|
            @graph.add_edge(name, dep)
          end
        end
        @modules_resolved = @graph.resolve
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
