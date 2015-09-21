# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails/service/version'

Gem::Specification.new do |spec|
  spec.name          = "rails-service"
  spec.version       = Rails::Service::VERSION
  spec.authors       = ["Łukasz Strzałkowski"]
  spec.email         = ["lukasz.strzalkowski@gmail.com"]

  spec.summary       = %q{Microservices on Rails}

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- spec/*`.split("\n")

  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency "rails", ">= 3.2.6", "< 5"
end
