require 'rails/service/admin/base_app'

module Rails
  module Service
    class DefaultAdminApp < BaseAdminApp
      # Matches both `/` & `/env`
      get /\A\/(env)?\z/, sidebar: 'Environment' do
        erb :env, locals: { env: ENV.sort }
      end
    end
  end
end
