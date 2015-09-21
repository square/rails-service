require 'spec_helper'

RSpec.describe 'Rails::Service::Engine routes', type: :routing do
  routes { Rails::Service::Engine.routes }

  describe '/_status' do
    it 'index' do
      expect(get: '/_status').
        to route_to(controller: 'rails/service/status', action: 'index')
    end

    it 'custom check' do
      expect(get: '/_status/custom_check').
        to route_to(controller: 'rails/service/status', action: 'custom_check')
    end
  end

  # TODO: Figure out how to stub request/or mock constraint
  pending '/_admin' do
    it 'index' do
      expect(get: '/_admin').
        to route_to(controller: 'rails/service/admin', action: 'environment')
    end

    it 'custom page' do
      expect(get: '/_admin/custom_page').
        to route_to(controller: 'rails/service/admin', action: 'custom_page')
      expect(post: '/_admin/custom_page').
        to route_to(controller: 'rails/service/admin', action: 'custom_page')
    end
  end
end
