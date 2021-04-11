Gem::Specification.new do |s|
    s.name        = 'Axentro-rb-util'
    s.version     = '0.0.1'
    s.summary     = "Tools for Axentro blockchain crypto in Ruby"
    s.description = "Sending transactions"
    s.authors     = ["Kingsley Hendrickse"]
    s.email       = 'kingsley@axentro.io'
    s.files       = Dir.glob("{lib,bin}/**/*")
    s.add_dependency("ed25519", "~> 1.2", ">=1.2.4")
    s.add_dependency('ed25519-hd-rb', '~> 0.0.1', '>=0.0.1')
    s.add_dependency 'faraday', '~> 1.0'
    s.homepage    =
      'https://rubygems.org/gems/axentro-rb-util'
    s.license       = 'MIT'
    s.require_path = "lib"

    s.add_development_dependency "bundler", "~> 1.3"
    s.add_development_dependency "rake"
    s.add_development_dependency "rspec"
  end