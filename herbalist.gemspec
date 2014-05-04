# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'herbalist/version'

Gem::Specification.new do |spec|
  spec.name          = "herbalist"
  spec.version       = Herbalist::VERSION
  spec.authors       = ["jduff"]
  spec.email         = ["duff.john@gmail.com"]
  spec.summary       = %q{Herbalist is a natural language measurements parser.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "alchemist", "~>0.1.7"
  spec.add_dependency "numerizer", "~>0.2.0"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
