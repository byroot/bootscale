# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bootscale/version'

Gem::Specification.new do |spec|
  spec.name          = 'bootscale'
  spec.version       = Bootscale::VERSION
  spec.authors       = ['Jean Boussier']
  spec.email         = ['jean.boussier@gmail.com']

  spec.summary       = %q{Speedup applications boot by caching require calls}
  spec.description   = %q{Inspired by Aaron Patterson's talk on the subject}
  spec.homepage      = "https://github.com/byroot/bootscale"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.9.3'
end
