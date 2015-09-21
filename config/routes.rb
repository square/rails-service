Rails::Service::Engine.routes.draw do
  constraints Rails::Service.config.status_routes_constraint do
    get '/_status(/:action)', to: 'status#index', as: :status
  end

  constraints Rails::Service.config.admin_routes_constraint do
    match '/_admin(/:action)', to: 'admin#environment', via: [:get, :post], as: :admin
  end
end
