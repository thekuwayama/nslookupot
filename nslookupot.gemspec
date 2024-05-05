# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nslookupot/version'

Gem::Specification.new do |spec|
  spec.name          = 'nslookupot'
  spec.version       = Nslookupot::VERSION
  spec.authors       = ['thekuwayama']
  spec.email         = ['thekuwayama@gmail.com']
  spec.summary       = 'nslookup over TLS'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/thekuwayama/nslookupot'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>=2.7.0'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.bindir        = 'exe'
  spec.executables   = ['nslookupot']

  spec.add_development_dependency 'bundler'
  spec.add_dependency             'base64'
  spec.add_dependency             'openssl'
  spec.add_dependency             'resolv', '~> 0.4.0'
end
