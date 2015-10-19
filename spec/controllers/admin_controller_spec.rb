require 'spec_helper'

RSpec.describe Rails::Service::AdminController, type: :controller do
  routes { Rails::Service::Engine.routes }
  render_views

  it 'renders environment action' do
    get :environment
    expect(response).to have_http_status(:ok)
    expect(response).to render_template(:environment)
  end

  it 'renders app manifest' do
    get :manifest
    expect(response).to have_http_status :ok
    expect(response).to render_template 'manifest'
    expect(assigns(:manifest)).to eq Rails::Service.manifest
    expect(response.body).to include 'fooxample'
  end

  it 'renders app config' do
    get :app_config
    expect(response).to have_http_status :ok
    expect(response).to render_template 'app_config'
    expect(assigns(:config)).to eq Rails::Service.app_config
    expect(response.body).to include 'foobar'
    expect(response.body).to_not include 'foobar2'
    expect(response.body).to include 'foobar-overwritten'
    expect(response.body).to include 'barfoo'
  end

  describe 'custom resolvers' do
    describe 'default' do
      it 'renders custom action included from lib/service/admin/actions' do
        get :foobar
        expect(response).to have_http_status :ok
        expect(response).to render_template 'foobar'
        expect(assigns(:foo)).to eq 'test'
        expect(response.body).to include 'OH HAI'
      end
    end

    describe 'custom module at custom path (configured in application.rb)' do
      it 'renders action from custom module' do
        get :custom
        expect(response).to have_http_status :ok
        expect(response.body).to include 'custom action'
      end
    end
  end
end
