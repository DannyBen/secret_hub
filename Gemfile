source "https://rubygems.org"

group :development, :test do
  gem 'byebug'
  gem 'lp'
  gem 'pretty_trace'
  gem 'rspec'
  gem 'rspec_approvals'
  gem 'runfile', require: false
  gem 'runfile-tasks', require: false
  gem 'simplecov'
  gem 'changelog_generator'

  # we are locking sinatra to 2.0.3 due to this issue:
  # https://github.com/sinatra/sinatra/issues/1476
  # gem 'sinatra', '2.0.3', require: false
  gem 'sinatra', require: false
end

gemspec

