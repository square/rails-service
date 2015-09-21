require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)
require 'rails/service'

require_relative '../lib/custom_admin_actions'

module Dummy
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true

    # Rails::Service configuration
    config.service.admin_action_modules << Foobar::CustomAdminActions
  end
end
