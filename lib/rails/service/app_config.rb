require 'yaml'
require 'erb'

require 'rails/service/core_ext/deep_struct'

module Rails
  module Service
    module AppConfig
      module_function

      def new(options = {})
        path = options.fetch(:path)
        logger = options.fetch(:logger)
        env = options.fetch(:env)

        if File.exist?(path)
          file = File.read(path)
          logger.info("loading app config file: #{path}")
          DeepStruct.new(YAML.load(ERB.new(file).result)[env.to_s])
        else
          logger.warn("app config file not found: #{path}")
          nil
        end
      end
    end
  end
end
