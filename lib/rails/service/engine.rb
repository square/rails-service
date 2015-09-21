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
      config.service = Rails::Service.config

      initializer 'rails.service.lograge' do |app|
        Rails::Service::Boot.lograge(app)
      end
    end
  end
end
