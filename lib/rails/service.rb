require 'rails/service/version'
require 'rails/service/config'
require 'rails/service/registry'
require 'rails/service/context'
require 'rails/service/manifest'
require 'rails/service/app_config'

require 'rails/service/container'
require 'rails/service/railtie'

require 'rails/service/modules/logging'
require 'rails/service/modules/config'
require 'rails/service/modules/status'
require 'rails/service/modules/admin'

module Rails
  module Service
    module_function

    class << self
      attr_reader :config, :context, :registry, :manifest, :app_config, :logger
    end

    def initialize!
      @config     = Config.new
      @context    = Context.new(config._for_context)
      @manifest   = Manifest.new(config._for_manifest)
      @registry   = Registry.new
      @app_config = AppConfig.new(config._for_app_config)
      @logger     = @config.logger

      load_initializer!

      nil
    end

    def configure
      yield config
    end

    # We're doing out-of-band initializer loading here because we want it loaded
    # before the regular rails init happens
    # TODO(lukasz) add logging and maybe make initializer filename configurable?
    def load_initializer!
      unless @initializer_loaded
        @initializer_loaded = true
        require Rails.root.join('config/initializers/rails_service')
      end
    end
  end
end
