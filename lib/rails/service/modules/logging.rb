require 'logger'

require 'rails/service/base_module'

module Rails
  module Service
    class LoggingModule < BaseModule

      def initialize(app)
        super(app)
        Rails::Service.registry.logger = Logger.new(STDOUT)
      end

      def init
        # require 'lograge'
        # return unless app.config.lograge.enable
        #
        # app.config.lograge.custom_options = lambda { |_event|
        #   { dc: app.config.service.dc, host: app.config.service.host, app: app.config.service.app }
        # }
        #
        # Lograge.setup(app)
      end

      def to_module
        @logger
      end
    end
  end
end
