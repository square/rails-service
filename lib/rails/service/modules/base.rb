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

        def self.dependencies(*args)
          @dependencies = args
        end

        def self._dependencies
          @dependencies || []
        end

        attr_reader :dependencies

        def initialize(deps = {})
          @dependencies = deps
        end
      end
    end
  end
end
