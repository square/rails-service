require 'rails/railtie'

module Rails
  module Service
    class Railtie < Rails::Railtie
      config.before_configuration do
        Rails::Service.initialize!
        config.service = Rails::Service.config
      end

      initializer 'rails.service' do |app|
        Rails::Service::Container.new(modules: [:config, :logging]).run!
      end
    end
  end
end
