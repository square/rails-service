require 'rails/service/admin/base_app'

module Rails
  module Service
    class DefaultAdminApp < BaseAdminApp
      get '/' do
        erb :test, layout: :layout
      end
    end
  end
end
