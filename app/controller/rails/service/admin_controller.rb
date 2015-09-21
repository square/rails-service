# TODO: Should this support JSON format too?
class Rails::Service::AdminController < Rails::Service::BaseController # rubocop:disable Style/ClassAndModuleChildren
  if Rails::Service.config.admin_action_modules.present?
    Rails::Service.config.admin_action_modules.each do |mod|
      prepend mod
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

  def routing; end

  def rails_properties; end

  def manifest
    @manifest = Rails::Service.manifest
  end

  def config
    @config = Rails::Service.app_config
  end
end
