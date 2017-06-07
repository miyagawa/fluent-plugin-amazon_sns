# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fluent/plugin/amazon_sns/version'

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-amazon_sns"
  spec.version       = Fluent::Plugin::AmazonSns::VERSION
  spec.authors       = ["Tatsuhiko Miyagawa"]
  spec.email         = ["miyagawa@bulknews.net"]
  spec.summary       = %q{Fluent output plugin to send to Amazon SNS}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/miyagawa/fluent-plugin-amazon_sns"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "fluentd", [">= 0.14.15", "<2 "]
  spec.add_dependency "aws-sdk", "~> 2"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
