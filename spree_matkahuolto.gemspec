# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spree_matkahuolto/version'

Gem::Specification.new do |spec|
  spec.name          = "spree_matkahuolto"
  spec.version       = SpreeMatkahuolto::VERSION
  spec.authors       = ["Silvain"]
  spec.email         = ["silvain@agencyleroy.com"]
  spec.summary       = "Spree extension for integration with the delivery service Matkahuolto"
  spec.description   = spec.summary
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_dependency 'spree_core', '~> 3.1.0.beta'
  spec.add_dependency "gyoku", "~> 1.0"
  spec.add_dependency "nori"
  spec.add_dependency "rest-client"
  spec.add_dependency "htmlentities"

end
