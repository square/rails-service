require 'rails/service/base_module'
require 'rails/service/admin/default_app'

module Rails
  module Service
    class AdminModule < BaseModule
      def init
        app.routes.append do
          scope BaseAdminApp::BASE_PATH do
            mount DefaultAdminApp => "/"
          end
        end
      end
    end
  end
end
