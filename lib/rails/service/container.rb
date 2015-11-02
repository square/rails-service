require 'rails/service/modules/base'
require 'rails/service/dependency_graph'

module Rails
  module Service
    class Container
      attr_accessor :modules, :modules_resolved

      def initialize(enabled = [])
        @graph = DependencyGraph.new
        @modules_enabled = enabled
        # TODO: Rename me to something better and less confusing
        @modules = {}
        @modules_resolved = {}
      end

      # TODO: Pass `app` for rails initializer to modules as dep.
      def init(app = nil)
        load_modules
        resolve_dependencies
        modules_call(:init)
      end

      def start
        modules_call(:start)
      end

      def stop
        modules_call(:stop)
      end

      private

      def modules_call(meth)
        @modules_resolved.each do |name, module_object|
          module_object.send(meth) if module_object.respond_to?(meth.to_sym)
        end
      end

      def load_modules
        modules = {}
        Rails::Service::Modules::Base.subclasses.each do |klass|
          name = resolve_module_name(klass)
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

        inject_dependencies(@graph.resolve)
      end

      # TODO: Since it'll be transformed to hash now, names *must* not be ambigious .
      def inject_dependencies(mods)
        mods.each do |mod|
          mod_klass =  @modules.fetch(mod)
          deps = unless mod_klass._dependencies.empty?
            @modules_resolved.slice(*mod_klass._dependencies)
          else
            {}
          end
          @modules_resolved[mod] = mod_klass.new(deps)
        end
      end

      # Ugh, what a terrible name, fixme maybe?
      def mod_constantize(mod)
        "Rails::Service::Modules::#{mod.to_s.classify}".constantize
      end

      def find_modules
        ObjectSpace.each_object(Class).select { |klass| klass < Rails::Service::Modules::Base }
      end
    end
  end
end
