# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'torkify/version'

Gem::Specification.new do |gem|
  gem.name          = "torkify"
  gem.version       = Torkify::VERSION
  gem.authors       = ["Jon Cairns"]
  gem.email         = ["jon@ggapps.co.uk"]
  gem.description   = %q{Easily hook up events to automated testing with tork}
  gem.summary       = %q{Torkify allows you to execute code after tests run, when using tork. You can create listeners which are called when tests are run and completed, allowing you to easily execute code and call system programs.}
  gem.homepage      = ""

  gem.add_development_dependency 'rspec'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
