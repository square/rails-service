require 'rails/service/base_module'
require 'rails/service/admin/base_app'
require 'rails/service/admin/default_app'

module Rails
  module Service
    class AdminModule < BaseModule
      def start
        admin_module = Sinatra.new do
          def self.name
            "Rails::Service::AdminModule"
          end

          Rails::Service::BaseAdminApp.subclasses.each do |klass|
            use(AdminModule.preconfigure_app(klass))
          end

          run
        end

        app.routes.append do
          mount admin_module => BaseAdminApp::BASE_PATH
        end
      end

      def self.preconfigure_app(klass)
        klass.set(:views, ["#{File.expand_path(File.dirname(__FILE__))}/../admin/views"] + klass.views)
      end
    end
  end
end
