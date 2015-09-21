class Rails::Service::BaseController < ActionController::Base # rubocop:disable Style/ClassAndModuleChildren
  protect_from_forgery with: :exception
end
