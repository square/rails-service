Rails.application.routes.draw do
  root to: 'dupa#yolo'
  mount Rails::Service::Engine => '/', as: :rails_service
end
