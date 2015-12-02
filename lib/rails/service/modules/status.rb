require 'rails/service/base_module'
require 'rails/service/status/default_app'

module Rails
  module Service
    class StatusModule < BaseModule
      dependencies :logging

      def init(logging)
        app.routes.append do
          scope BaseStatusApp::BASE_PATH do
            mount DefaultStatusApp => "/"
          end
        end
      end
    end
  end
end
