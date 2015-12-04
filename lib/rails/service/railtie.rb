require 'rails/railtie'

module Rails
  module Service
    class Railtie < Rails::Railtie
      config.before_configuration do
        Rails::Service.initialize!
        config.service = Rails::Service.config
      end

      initializer 'rails.service', before: 'load_config_initializers' do |app|
        Rails::Service::Container.new(modules: app.config.service.modules).run!(app)
      end
    end
  end
end
