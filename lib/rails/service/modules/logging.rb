require 'logger'

require 'rails/service/base_module'

module Rails
  module Service
    class LoggingModule < BaseModule
      def initialize(app)
        super(app)
        @logger = Logger.new(STDOUT)
      end

      def to_module
        @logger
      end

      def init
        
      end
    end
  end
end
