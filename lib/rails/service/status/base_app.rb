require "sinatra/base"

module Rails
  module Service
    class BaseStatusApp < Sinatra::Base
      BASE_PATH = "/_status".freeze

      protected

      STATUS_TYPES = { ok: 200, warning: 200, critical: 503 }.freeze

      # TODO: Do type checking on value returned by `yield` and raise helpful ArgumentError
      def self.status(path)
        status_and_params_hash = yield
        status_type, params_hash = status_and_params_hash

        raise ArgumentError unless STATUS_TYPES.key?(status_type)

        get(path) do
          status(STATUS_TYPES.fetch(status_type))
          headers('Server-Status' => status.to_s.capitalize)
          content_type('application/json')
          body({ status: status_type.to_s }.merge(params_hash).to_json)
        end
      end
    end
  end
end
