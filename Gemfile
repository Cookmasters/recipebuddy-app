# frozen_string_literal: false

source 'https://rubygems.org'
ruby '2.4.2'

# Networking gems
gem 'bootstrap', '~> 4.0.0.beta2'
gem 'http'

# Development/Debugging related
gem 'pry' # to run console in production
gem 'rake' # to run console in production

# Web app related
gem 'econfig'
gem 'puma'
gem 'roda'
gem 'slim'

# Representers
gem 'multi_json'
gem 'roar'

group :test do
  gem 'minitest'
  gem 'minitest-rg'
  gem 'rack-test'
  gem 'simplecov'
  gem 'vcr'
  gem 'webmock'
end

group :development, :test do
  gem 'rerun'

  gem 'flog'
  gem 'reek'
  gem 'rubocop'
end
