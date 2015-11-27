require 'rails/service/status/base_app'

module Rails
  module Service
    class DefaultStatusApp < BaseStatusApp
      status '/' do
        [:ok, time: Time.current]
      end

      SELECT_ONE = 'SELECT 1'.freeze

      status '/db' do
        begin
          time = Benchmark.realtime { ActiveRecord::Base.connection.execute(SELECT_ONE).first }
          [:ok, time: (time * 1_000).round(4)]
        rescue => ex
          [:critical, exception: ex.message, class: ex.class.to_s]
        end
      end
    end
  end
end
