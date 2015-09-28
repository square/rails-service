require 'spec_helper'

RSpec.describe Rails::Service::AppConfig do
  let(:path) { 'config/app-config.yaml' }
  let(:logger) { double(:logger) }
  let(:env) { 'test' }
  let(:config) { described_class.new(path: path, logger: logger, env: env) }

  around do |exmaple|
    old_root = Rails.root
    begin
      Rails.application.config.root = File.expand_path('spec/rails_app')
      example.run
    ensure
      Rails.application.config.root = old_root
    end
  end

  describe 'loading yaml config' do
    before do
      allow(logger).to receive(:info)
    end

    it 'load config by environment' do
      expect(config.barfoo).to eq 'barfoo'
    end

    it 'should inherit defaults' do
      expect(config.foo.bar).to eq 'foobar'
    end

    it 'should overwrite inherited configs' do
      expect(config.foobar).to eq 'foobar-overwritten'
    end
  end
end
