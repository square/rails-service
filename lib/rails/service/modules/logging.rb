require 'logger'

require 'rails/service/modules/base'

module Rails
  module Service
    module Modules
      class Logging < Base
        def initialize
          @logger = Logger.new(STDOUT)
        end

        def to_module
          @logger
        end

        def init
          puts "logging INIT"
        end
      end
    end
  end
end
