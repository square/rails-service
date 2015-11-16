require 'rails/service/modules/base'

module Rails
  module Service
    module Modules
      class Config < Base
        dependencies :logging

        def init(logging)
          self.logging = logging
          logging.debug("initializing config")
        end
      end
    end
  end
end
