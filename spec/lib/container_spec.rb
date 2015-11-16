require 'spec_helper'
require 'logger'

RSpec.describe Rails::Service::Container do
  let(:modules) { [] }
  let(:options) { { app: nil, modules: modules } }
  let(:container) { described_class.new(options) }

  let(:base) { Rails::Service::Modules::Base }
  let!(:foobar) {
    Class.new(base) do
      dependencies :config_test, :logger_test

      def init(config, logger)
        self.config_test = config
        self.logger_test = logger
      end
    end
  }

  let!(:config) {
    Class.new(base) do
      dependencies :logger_test

      def init(logger)
        self.logger_test = logger
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
    allow(config).to receive(:to_s).and_return("config_test")
    allow(logger).to receive(:to_s).and_return("logger_test")
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

      expect(container.modules[:foobar].logger_test).to be_a Logger
      expect(container.modules[:foobar].config_test).to be_a Hash

      expect(container.modules[:config_test].logger_test).to be_a Logger
    end

    context 'class with broken dependency' do
      let(:with_broken_dep) {
        Class.new(base) do
          dependencies :yolo
        end
      }

      it 'should raise error because dependency is undefined' do
        expect { container.run! }.to raise_error ArgumentError
      end
    end
  end
end
