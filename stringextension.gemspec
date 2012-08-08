# -*- encoding: utf-8 -*-
require File.expand_path('../lib/stringextension/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Hermann Faß"]
  gem.email         = ["hf@vonabiszet.de"]
  gem.description   = %q{Enhancing Ruby's String class.}
  gem.summary       = %q{Introduces methods like String#wrap() or String#to_ascii().}
  gem.homepage      = "https://github.com/hermannfass/stringextension"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "stringextension"
  gem.require_paths = ["lib"]
  gem.version       = Stringextension::VERSION
end
