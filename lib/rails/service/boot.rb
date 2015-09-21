module Rails
  module Service
    module Boot
      module_function

      STATUS_CONTROLLER = 'Rails::Service::StatusController'.freeze

      def lograge(app)
        return unless defined?(Lograge) && !app.config.lograge.enable

        app.config.lograge.ignore_custom = lambda { |event|
          !app.config.service.status_logs_enabled && event.payload[:controller] == STATUS_CONTROLLER
        }

        app.config.lograge.custom_options = lambda { |_event|
          { dc: app.config.service.dc, host: app.config.service.host, app: app.config.service.app }
        }

        Lograge.setup(app)
      end
    end
  end
end
