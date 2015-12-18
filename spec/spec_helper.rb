ENV['RAILS_ENV'] = 'test'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'rails/service'
require 'pry'
require 'rspec'
require 'pathname'

FIXTURES_ROOT = Pathname.new(File.expand_path('spec/fixtures'))

RSpec.configure do |config|
  config.color = true
  config.formatter = :progress

  config.before(:all) do
    # allow(Rails).to receive(:root).and_return()
    module Rails
      def self.root
        Pathname.new(File.expand_path('spec/fixtures'))
      end
    end
  end
end
