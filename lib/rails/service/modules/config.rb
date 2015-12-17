require 'rails/service/base_module'

module Rails
  module Service
    class ConfigModule < BaseModule
      dependencies :logging

      def init(logging)
        Rails::Service.registry.logger.debug("initializing config")
      end
    end
  end
end
