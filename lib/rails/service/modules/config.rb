require 'rails/service/modules/base'

module Rails
  module Service
    module Modules
      class Config < Base
        dependencies :logger

        def initialize(logger)
          self.logger = logger
        end

        def init
          logger.debug("initializing config")
        end
      end
    end
  end
end
