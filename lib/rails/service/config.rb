require 'socket'

module Rails
  module Service
    class Config
      attr_writer :app, :dc, :host

      attr_accessor :process_id, :modules

      attr_writer :status_logs_enabled, :manifest_path, :logger, :env,
        :app_config_path

      def app
        @app ||= begin
          if Rails::Service.manifest.respond_to?(:app)
            Rails::Service.manifest.app
          else
            Rails.application.class.parent_name.downcase
          end
        end
      end

      def modules
        @modules ||= [:config, :logging, :status, :admin]
      end

      def dc
        @dc ||= ENV.fetch('DATACENTER', 'local').downcase
      end

      def host
        @host ||= Socket.gethostname
      end

      def process_id
        @process_id ||= lambda { |app, dc, host, pid, _rev| "#{app}:#{dc}:#{host}:#{pid}:#{SecureRandom.uuid}".freeze }
      end

      def pid
        @pid ||= Process.pid
      end

      def rev
        @rev ||= File.exist?('REVISION') ? File.read('REVISION') : '(none)'
      end

      def env
        @env ||= Rails.env
      end

      def logger
        @logger ||= Logger.new(Rails.root.join('log/service.log'))
      end

      def manifest_path
        @manifest_path ||= Rails.root.join('app-manifest.yaml')
      end

      def app_config_path
        @app_conifg_path ||= Rails.root.join('config/app-config.yaml')
      end

      def status_logs_enabled
        @status_logs_enabled ||= false
      end

      def _for_context
        {
          app: app,
          dc: dc,
          host: host,
          env: env,
          pid: pid,
          rev: rev,
          process_id: process_id.call(app, dc, host, pid, rev),
          logger: logger,
        }
      end

      def _for_manifest
        {
          path: manifest_path,
          logger: logger,
        }
      end

      def _for_app_config
        {
          path: app_config_path,
          logger: logger,
          env: env,
        }
      end
    end
  end
end
