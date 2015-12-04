require 'rails/service/admin/base_app'

module Rails
  module Service
    class DefaultAdminApp < BaseAdminApp
      sidebar "Environment" => "/env"

      # Matches both `/` & `/env`
      get /\A\/(env)?\z/ do
        erb :env, locals: { env: ENV.sort }
      end
    end
  end
end
