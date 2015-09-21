require 'spec_helper'

RSpec.describe Rails::Service::StatusController, type: :controller do
  routes { Rails::Service::Engine.routes }

  it 'renders root status endpoint' do
    time = Time.current
    expect(Time).to receive(:current).and_return(time)
    get :index
    expect(response).to have_http_status :ok
    expect(response.body).to eq({ status: 'ok', time: time }.to_json)
  end

  it 'renders custom status endpoints from lib/service/status/actions.rb' do
    get :db
    expect(response).to have_http_status :ok
    status_hash = JSON.parse(response.body)
    expect(status_hash['status']).to eq 'ok'
    expect(status_hash['time']).to be_kind_of(Float)
  end
end
