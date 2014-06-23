# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sense_of_place/version'

Gem::Specification.new do |spec|
  spec.name          = "sense_of_place"
  spec.version       = SenseOfPlace::VERSION
  spec.authors       = ["Thai Pangsakulyanont"]
  spec.email         = ["org.yi.dttvb@gmail.com"]
  spec.summary       = %q{Detect location based on network settings.}
  spec.homepage      = "https://github.com/dtinth/sense_of_place"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
