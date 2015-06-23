# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dynamo-local-ruby/version'

Gem::Specification.new do |spec|
  spec.name          = 'dynamo-local-ruby'
  spec.version       = DynamoLocalRuby::VERSION
  spec.authors       = ['Peak Xu']
  spec.email         = ['peak.xu@gmail.com']
  spec.summary       = 'Ruby wrapper around DynamoDB Local for use with AWS-SDK'
  spec.description   = 'Ruby wrapper around DynamoDB Local for use with AWS-SDK'
  spec.homepage      = 'https://github.com/peakxu/dynamo-local-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin/) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)/)
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'aws-sdk', '~> 2.0'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop'
end
