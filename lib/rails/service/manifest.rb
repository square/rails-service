require 'yaml'
require 'erb'

require 'rails/service/core_ext/deep_struct'

module Rails
  module Service
    module Manifest
      module_function

      def new(options = {})
        path = options.fetch(:path)
        logger = options.fetch(:logger)

        path = Rails.root.join(path)
        if File.exist?(path)
          file = File.read(path)
          logger.info("loading manifest file: #{path}")
          DeepStruct.new(YAML.load(ERB.new(file).result))
        else
          logger.warn("manifest file not found: #{path}")
          nil
        end
      end
    end
  end
end
