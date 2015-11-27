require 'rails/service/base_module'

module Rails
  module Service
    class ConfigModule < BaseModule
      dependencies :logging

      def init(logging)
        self.logging = logging
        logging.debug("initializing config")
      end
    end
  end
end
