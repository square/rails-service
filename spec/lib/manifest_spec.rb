require 'spec_helper'

RSpec.describe Rails::Service::Manifest do
  let(:path) { 'app-manifest.yaml' }
  let(:logger) { double(:logger) }
  let(:manifest) { described_class.new(path: path, logger: logger) }

  before do
    @root_old = Rails.root
    Rails.application.config.root = File.expand_path('spec/fixtures')
  end

  after do
    Rails.application.config.root = @root_old
  end

  describe 'chain method access to properties' do
    before do
      allow(logger).to receive(:info)
    end

    it 'should work with nested properties' do
      expect(manifest.setup.nodes).to be_kind_of(Array)
    end

    it 'should evaluate erb' do
      expect(manifest.magic).to eq 4
    end

    it 'should convert to hash' do
      expect(manifest.to_h).to eq(
        'app' => 'fooxample',
        'setup' => {
          'nodes' => [
            'abc123.nyc.acme',
            'abc456.nyc.acme',
            'abc789.nyc.acme',
          ],
        },
        'magic' => 4,
      )
    end
  end

  describe 'loading file' do
    context 'file not exists' do
      let(:path) { 'dobrypies.yaml' }

      it 'log that file was not' do
        expect(logger).to receive(:warn)
        manifest
      end
    end

    context 'file exists' do
      it 'log that file was loaded' do
        expect(logger).to receive(:info)
        manifest
      end
    end
  end
end
