require 'spec_helper'

RSpec.describe Rails::Service::Context do
  let(:defaults) { { app: 'square', dc: 'nyc1', host: 'abc1' } }
  let(:context) { described_class.new(defaults) }

  describe 'defaults' do
    it 'should set default values' do
      expect(context.app).to eq 'square'
      expect(context.dc).to eq 'nyc1'
      expect(context.host).to eq 'abc1'
    end
  end

  describe 'dynamic setters/getters' do
    it 'should set property' do
      context.foobar = 'foobar'
      expect(context.foobar).to eq 'foobar'
      expect(context).to respond_to(:foobar)
    end
  end
end
