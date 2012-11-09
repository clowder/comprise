# -*- encoding: utf-8 -*-
require File.expand_path('../lib/comprise/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Chris Lowder"]
  gem.email         = ["clowder@gmail.com"]
  gem.description   = %q{Comprise brings basic List Comprehension functionality to Ruby.}
  gem.summary       = %q{List Comprehension for Ruby.}
  gem.homepage      = "http://clowder.github.com/comprise"

  gem.files         = %w{LICENSE
                         README.md
                         comprise.gemspec
                         lib/comprise.rb
                         lib/comprise/list_comprehension.rb
                         lib/comprise/version.rb
                         spec/comprise/list_comprehension_spec.rb}
  gem.test_files    = %w{spec/comprise/list_comprehension_spec.rb}
  gem.name          = "comprise"
  gem.require_paths = ["lib"]
  gem.version       = Comprise::VERSION


  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'rb-fsevent', '~> 0.9.1'
end
