ENV['RAILS_ENV'] = 'test'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

#require File.expand_path('../../spec/rails_app/config/environment.rb', __FILE__)
require 'rails/service'

require 'pry'

require 'rspec'
#require 'rspec/rails'

require 'pathname'

RAILS_APP_ROOT = Pathname.new(File.expand_path('./spec/rails_app'))

RSpec.configure do |config|
  config.color = true
  config.formatter = :progress
end
