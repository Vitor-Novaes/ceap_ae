# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.4'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.3'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.12.0', require: false

# [https://github.com/roo-rb/roo]
gem 'roo', '~> 2.9.0'

# [https://github.com/jnunemaker/httparty]
gem 'httparty', '~> 0.20'

# [https://github.com/rubyzip/rubyzip]
gem 'rubyzip', '~> 2.3.2'

# [https://github.com/procore/blueprinter]
gem 'blueprinter', '~> 0.25'

# [https://github.com/ondrejbartas/sidekiq-cron]
gem 'sidekiq', '~> 6.5.1'

# [https://github.com/ondrejbartas/sidekiq-cron]
gem 'sidekiq-cron', '~> 1.7.0'

# [https://github.com/kaminari/kaminari]
gem 'api-pagination', '~> 5.0.0'

# [https://github.com/davidcelis/api-pagination]
gem 'kaminari', '~> 1.2.2'

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-json_expectations'
  gem 'rspec-rails'
  gem 'rubycritic', require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.2'

  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  gem 'spring', '~> 4.0'

  # https://www.fastruby.io/blog/rails/upgrades/upgrade-rails-6-1-to-7-0.html
  # gem 'spring-watcher-listen', '~> 2.0.0' # conflict error Rails 7 railiies ActiveSupport::Dependencies:Module
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'rspec-sidekiq'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'webmock'
end
