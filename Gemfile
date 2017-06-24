source "https://rubygems.org"

group :test do
  gem "rake"
  gem "puppet", ENV['PUPPET_GEM_VERSION'] || '~> 4.0'
  gem "rspec", '~> 3.4.0'
  gem "rspec-puppet", :git => 'https://github.com/rodjek/rspec-puppet.git'
  gem "puppetlabs_spec_helper", '~> 2.1'
  gem "metadata-json-lint"
  gem "rspec-puppet-facts"
  gem 'rubocop', '0.40.0'
  gem 'simplecov', '>= 0.11.0'
  gem 'simplecov-console'
  gem 'puppet-lint', '>= 2.0.0'
  gem 'puppet-syntax', :git => 'https://github.com/voxpupuli/puppet-syntax'
  gem 'json_pure', '<= 2.0.1' if RUBY_VERSION < '2.0.0'
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
