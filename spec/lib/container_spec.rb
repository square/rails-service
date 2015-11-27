require 'spec_helper'
require 'logger'

RSpec.describe Rails::Service::Container do
  let(:modules) { [] }
  let(:options) { { app: nil, modules: modules } }
  let(:container) { described_class.new(options) }

  let(:base) { Rails::Service::BaseModule }
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

      def initialize(app)
        super(app)

        @io = StringIO.new
        @logger = Logger.new(@io)
      end

      def to_module
        @logger
      end
    end
  }

  let(:app) { nil }

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

      container.run!(app)
    end

    it 'should inject dependencies' do
      container.run!(app)

      expect(container.modules_resolved[:foobar].logger_test).to be_a Logger
      expect(container.modules_resolved[:foobar].config_test).to be_a Hash

      expect(container.modules_resolved[:config_test].logger_test).to be_a Logger
    end

    context 'class with broken dependency' do
      let!(:with_broken_dep) {
        Class.new(base) do
          dependencies :yolo
        end
      }

      let(:modules) { [:with_broken_dep] }

      before do
        allow(with_broken_dep).to receive(:to_s).and_return("with_broken_dep")
      end

      it 'should raise error because dependency is undefined' do
        expect { container.run!(app); }.to raise_error ArgumentError
      end
    end
  end

  describe 'modules' do
    let(:modules) { [:foobar] }

    it 'should enabled only one module w/ its dependencies' do
      container.run!(app)
      expect(container.modules_resolved.length).to eq 3
    end
  end
end
