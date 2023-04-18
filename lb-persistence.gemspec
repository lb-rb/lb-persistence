# frozen_string_literal: true

require File.expand_path('lib/lb/persistence/version', __dir__)

Gem::Specification.new do |gem|
  gem.name        = 'lb-persistence'
  gem.version     = LB::Persistence::VERSION.dup
  gem.authors     = ['Firas Zaidan']
  gem.email       = ['firas@zaidan.de']
  gem.description = 'LB Persistence API'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/lb-rb/lb-persistence'
  gem.license     = 'MIT'

  gem.bindir                = 'bin'
  gem.require_paths         = %w[lib bin]
  gem.files                 = `git ls-files`
                              .split($INPUT_RECORD_SEPARATOR)
  gem.executables           = `git ls-files -- bin/*`
                              .split("\n").map { |f| File.basename(f) }
  gem.extra_rdoc_files      = %w[README.md]
  gem.required_ruby_version = '>= 2.7'

  gem.add_dependency 'dry-struct',       '~> 1.6'
  gem.add_dependency 'rom',              '~> 5.3'
  gem.add_dependency 'rom-sql',          '~> 3.6'

  gem.add_development_dependency 'rake',       '~> 13.0.6'
  gem.add_development_dependency 'rspec',      '~> 3.12.0'
  gem.add_development_dependency 'rspec-core', '~> 3.12.1'
  gem.add_development_dependency 'rubocop',    '~> 1.5'
  gem.add_development_dependency 'sqlite3',    '~> 1.6'
  gem.metadata['rubygems_mfa_required'] = 'true'
end
