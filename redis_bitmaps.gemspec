# -*- encoding: utf-8 -*-
require File.expand_path('../lib/redis_bitmaps/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jake Moffatt"]
  gem.email         = ["jakeonrails@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "redis_bitmaps"
  gem.require_paths = ["lib"]
  gem.version       = RedisBitmaps::VERSION

  gem.add_dependency 'redis'
  gem.add_dependency 'bitset'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'activerecord', '~> 3.0.0'
  gem.add_development_dependency 'sqlite3-ruby'
end
