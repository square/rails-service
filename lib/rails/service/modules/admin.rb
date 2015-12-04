require 'rails/service/base_module'
require 'rails/service/admin/base_app'
require 'rails/service/admin/default_app'

module Rails
  module Service
    class AdminModule < BaseModule
      def init
        admin_module = Sinatra.new do
          def self.name
            "Rails::Service::AdminModule"
          end

          Rails::Service::BaseAdminApp.subclasses.each do |klass|
            use klass
          end

          run
        end

        app.routes.append do
          mount admin_module => BaseAdminApp::BASE_PATH
        end
      end
    end
  end
end
