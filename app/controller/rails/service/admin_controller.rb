# TODO: Should this support JSON format too?
class Rails::Service::AdminController < Rails::Service::BaseController # rubocop:disable Style/ClassAndModuleChildren
  if Rails::Service.config.admin_action_modules.present?
    Rails::Service.config.admin_action_modules.each do |mod|
      # We'd prefer to use `prepend` here, but we need to be compat
      # with jruby17
      include mod
    end
  end

  layout 'admin'

  append_view_path Rails::Service.config.admin_view_resolvers

  before_filter do
    @service_context ||= Rails::Service.context
  end

  def environment
    @env = ENV.sort
  end

  if Rails.env.developement?
    # Those endpoints basically just embbed the default
    # rails actions provided by the framework and by default
    # they're enabled in developement env only.
    def routing; end

    def rails_properties; end
  end

  def manifest
    @manifest = Rails::Service.manifest
  end

  def config
    @config = Rails::Service.app_config
  end
end
