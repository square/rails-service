require 'spec_helper'

RSpec.describe Rails::Service::Container do
  let(:modules_enabled) { [] }
  let(:container) { described_class.new(modules_enabled) }

  let(:base) { Rails::Service::Modules::Base }
  let!(:foobar) {
    Class.new(base) do
      dependencies :foo, :bar
      def init
        puts "foobar"
      end
    end
  }

  let!(:bar) {
    Class.new(base) do
      dependencies :foo
      def init
        puts "bar"
      end
    end
  }

  let!(:foo) {
    Class.new(base) do
      def init
        puts "foo"
      end
    end
  }

  before do
    allow(foobar).to receive(:to_s).and_return("foobar")
    allow(foo).to receive(:to_s).and_return("foo")
    allow(bar).to receive(:to_s).and_return("bar")
  end

  describe 'dependencies' do
    let(:modules_enabled) { [:foo_bar] }

    it 'should resolve module deps' do
      expect_any_instance_of(foobar).to receive :init
      expect_any_instance_of(foo).to receive :init
      expect_any_instance_of(bar).to receive :init

      container.init
    end
  end
end
