require 'spec_helper'

RSpec.describe Rails::Service::Container do
  let(:modules_enabled) { [] }
  let(:container) { described_class.new(modules_enabled) }

  let(:base) { Rails::Service::Modules::Base }
  let!(:foobar) {
    Class.new(base) do
      dependencies :config, :logger

      def initialize(deps = {})
        self.config = deps[:config]
        self.logger = deps[:logger]
      end

      def init
        puts "foobar"
      end
    end
  }

  let!(:config) {
    Class.new(base) do
      dependencies :logger

      def initialize(deps = {})
        self.logger = deps[:logger]
      end

      def init
        puts "bar"
      end
    end
  }

  let!(:logger) {
    Class.new(base) do
      def init
        puts "foo"
      end
    end
  }

  before do
    allow(foobar).to receive(:to_s).and_return("foobar")
    allow(config).to receive(:to_s).and_return("config")
    allow(logger).to receive(:to_s).and_return("logger")
  end

  describe 'dependencies' do
    let(:modules_enabled) { [:foobar] }

    it 'should resolve module deps' do
      expect_any_instance_of(foobar).to receive :init
      expect_any_instance_of(config).to receive :init
      expect_any_instance_of(logger).to receive :init

      container.init
    end

    it 'should inject dependencies' do
      container.init

      expect(container.modules_resolved[:foobar].logger.class).to eq logger
      expect(container.modules_resolved[:foobar].config.class).to eq config

      expect(container.modules_resolved[:config].logger.class).to eq logger
    end
  end
end
