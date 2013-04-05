# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'torkify/version'

Gem::Specification.new do |gem|
  gem.name          = "torkify"
  gem.version       = Torkify::VERSION
  gem.authors       = ["Jon Cairns"]
  gem.email         = ["jon@joncairns.com"]
  gem.description   = %q{Easily create callbacks for automated testing with tork}
  gem.summary       = %q{Torkify allows you to execute code after tests run, when using the tork gem for automated testing. You can create listeners which are called when tests are run, and when they fail or pass. This allows you to easily execute code and call system programs.}
  gem.homepage      = "https://github.com/joonty/torkify"

  gem.add_dependency 'json', '~> 1.7.7'
  gem.add_dependency 'log4r', '~> 1.1.10'

  gem.add_development_dependency 'rspec', '~> 2.13.0'
  gem.add_development_dependency 'rake', '~> 10.0.3'
  gem.add_development_dependency 'tork', '~> 19.2.1'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
