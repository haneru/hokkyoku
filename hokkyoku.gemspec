# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hokkyoku/version'

Gem::Specification.new do |spec|
  spec.name          = "hokkyoku"
  spec.version       = Hokkyoku::VERSION
  spec.authors       = ["haneru"]
  spec.email         = ["haneru3@gmail.com"]

  spec.summary       = %q{company information.}
  spec.description   = %q{hokkyoku（北極）give you company's stock information in japan.}
  spec.homepage      = "https://github.com/haneru/hokkyoku"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_runtime_dependency 'nokogiri'
  spec.add_development_dependency 'pry'
  spec.add_dependency 'thor'
end
