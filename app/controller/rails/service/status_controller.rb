class Rails::Service::StatusController < Rails::Service::BaseController # rubocop:disable Style/ClassAndModuleChildren
  if Rails::Service.config.status_action_modules.present?
    Rails::Service.config.status_action_modules.each do |mod|
      prepend mod
    end
  end

  def index
    render_status :ok, time: Time.current
  end

  SELECT_ONE = 'SELECT 1'.freeze

  def db
    time = Benchmark.realtime { ActiveRecord::Base.connection.execute(SELECT_ONE).first }
    render_status :ok, time: (time * 1_000).round(4)

  rescue => ex
    render_status :critical, exception: ex.message, class: ex.class.to_s
  end

  protected

  STATUS_TYPES = [:ok, :warning, :critical].freeze

  def render_status(status, params = {})
    raise ArgumentError unless STATUS_TYPES.include?(status)

    http_status = status == :critical ? :service_unavailable : :ok
    response.headers['Server-Status'] = status.to_s.capitalize

    render status: http_status, json: { status: status }.merge(params)
  end
end
