require 'rails/service/base_module'
require 'rails/service/status/base_app'
require 'rails/service/status/default_app'

module Rails
  module Service
    class StatusModule < BaseModule
      def start
        status_module = Sinatra.new do
          def self.name
            "Rails::Service::StatusModule"
          end

          Rails::Service::BaseStatusApp.subclasses.each do |klass|
            use klass
          end

          run
        end

        app.routes.append do
          mount status_module => BaseStatusApp::BASE_PATH
        end
      end
    end
  end
end
