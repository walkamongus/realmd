source "https://rubygems.org"

group :test do
  gem "rake"
  gem "puppet", ENV['PUPPET_GEM_VERSION'] || '~> 4.0'
  gem "rspec", '~> 3.4.0'
  gem "rspec-puppet", :git => 'https://github.com/rodjek/rspec-puppet.git'
  gem "puppetlabs_spec_helper", '>= 1.2.1'
  gem "metadata-json-lint"
  gem "rspec-puppet-facts"
  gem 'rubocop', '0.40.0'
  gem 'simplecov', '>= 0.11.0'
  gem 'simplecov-console'
  gem 'json_pure', '~> 1.8.3'

  gem 'puppet-lint', '>= 2.0.0'
  gem "puppet-lint-absolute_classname-check"
  gem "puppet-lint-leading_zero-check"
  gem "puppet-lint-trailing_comma-check"
  gem "puppet-lint-version_comparison-check"
  gem "puppet-lint-classes_and_types_beginning_with_digits-check"
  gem "puppet-lint-unquoted_string-check"
end

group :development do
  gem "travis"              if RUBY_VERSION >= '2.1.0'
  gem "travis-lint"         if RUBY_VERSION >= '2.1.0'
  gem "guard-rake"          if RUBY_VERSION >= '2.2.5' # per dependency https://rubygems.org/gems/ruby_dep
  gem "puppet-blacksmith"
end

group :system_tests do
  gem 'beaker'       if RUBY_VERSION >= '2.1.8'
  gem 'beaker-rspec' if RUBY_VERSION >= '2.1.8'
end
