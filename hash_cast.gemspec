# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hash_cast/version'

Gem::Specification.new do |spec|
  spec.name          = "hash_cast"
  spec.version       = HashCast::VERSION
  spec.authors       = ["Albert Gazizov"]
  spec.email         = ["deeper4k@gmail.com"]
  spec.description   = %q{Declarative Hash Caster}
  spec.summary       = %q{Declarative Hash Caster}
  spec.homepage      = "http://github.com/droidlabs/hash_cast"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
