require 'rails/service/version'
require 'rails/service/config'
require 'rails/service/context'
require 'rails/service/manifest'
require 'rails/service/app_config'

module Rails
  module Service
    module_function

    def config
      @config ||= Config.new
    end

    def context
      @context ||= Context.new(config._for_context)
    end

    def manifest
      @manifest ||= Manifest.new(config._for_manifest)
    end

    def app_config
      @app_config ||= AppConfig.new(config._for_app_config)
    end

    def logger
      @logger ||= Logger.new('log/service.log')
    end
  end
end

require 'rails/service/engine'
