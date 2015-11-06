require 'spec_helper'

RSpec.describe Rails::Service::Container do
  let(:modules) { [] }
  let(:options) { { app: nil, modules: modules } }
  let(:container) { described_class.new(options) }

  let(:base) { Rails::Service::Modules::Base }
  let!(:foobar) {
    Class.new(base) do
      dependencies :config, :logger

      def init(config, logger)
        self.config = config
        self.logger = logger
      end
    end
  }

  let!(:config) {
    Class.new(base) do
      dependencies :logger

      def init(logger)
        self.logger = logger
      end

      def to_module
        {}
      end
    end
  }

  let!(:logger) {
    Class.new(base) do
      attr_accessor :io

      def initialize
        @io = StringIO.new
        @logger = Logger.new(@io)
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
    let(:modules) { [:foobar] }

    it 'should resolve module deps' do
      expect_any_instance_of(foobar).to receive :init
      expect_any_instance_of(config).to receive :init
      expect_any_instance_of(logger).to receive :init

      container.run!
    end

    it 'should inject dependencies' do
      container.run!

      expect(container.modules[:foobar].logger).to be_a Logger
      expect(container.modules[:foobar].config).to be_a Hash

      expect(container.modules[:config].logger).to be_a Logger
    end
  end
end
