require 'spec_helper'

RSpec.describe Rails::Service::Container do
  let(:modules_enabled) { [] }
  let(:container) { described_class.new(modules_enabled) }

  let(:base) { Rails::Service::Modules::Base }
  let!(:foobar) {
    Class.new(base) do
      dependencies :config, :logger

      def initialize(config, logger)
        self.config = config
        self.logger = logger
      end

      def init
        puts "foobar"
      end
    end
  }

  let!(:config) {
    Class.new(base) do
      dependencies :logger

      def initialize(logger)
        self.logger = logger
      end

      def init
        puts "config"
      end

      def to_module
        {}
      end
    end
  }

  let!(:logger) {
    Class.new(base) do
      def initialize
        @logger = Logger.new(STDOUT)
      end

      def init
        puts "logger"
      end

      def to_module
        @logger
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

      expect(container.modules_resolved[:foobar].logger).to be_a Logger
      expect(container.modules_resolved[:foobar].config).to be_a Hash

      expect(container.modules_resolved[:config].logger).to be_a Logger
    end
  end
end
