require 'rails/service/version'
require 'rails/service/config'
require 'rails/service/context'
require 'rails/service/manifest'
require 'rails/service/app_config'

module Rails
  module Service
    module_function

    class << self
      attr_reader :config, :context, :manifest, :app_config, :logger
    end

    def initialize!
      @config     = Config.new
      @context    = Context.new(config._for_context)
      @manifest   = Manifest.new(config._for_manifest)
      @app_config = AppConfig.new(config._for_app_config)
      @logger     = @config.logger
    end
  end
end

require 'rails/service/engine'
