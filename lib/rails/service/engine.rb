require 'rails/engine'
require 'rails/service'
require 'rails/service/context'
require 'rails/service/boot'

module Rails
  module Service
    class Engine < Rails::Engine
      engine_name 'rails-service'
      isolate_namespace Rails::Service

      config.autoload_paths << File.expand_path('../../../', __FILE__)

      # Serve static asssets for Admin UI.
      config.serve_static_assets = true

      config.before_configuration do
        Rails::Service.initialize!
        config.service = Rails::Service.config
      end

      config.to_prepare do
        # TODO: Do config/manifest reloading here
      end

      initializer 'rails.service.lograge' do |app|
        Rails::Service::Boot.lograge(app)
      end

      initializer 'rails.service.static_assets' do |app|
        app.middleware.use(::ActionDispatch::Static, "#{root}/public")
      end
    end
  end
end
