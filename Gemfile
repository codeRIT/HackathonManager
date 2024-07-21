source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Use Ruby version defined in .ruby-version
ruby '>= 3.0.6'

##########################################################################
# Rails default gems

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.1.3'

# Use sqlite3 as the database for Active Record
# gem "sqlite3", "~> 1.4"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

##########################################################################

# Use mysql2 as the database for Active Record
gem 'mysql2', '>= 0.4.4', '< 0.6.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'

# CORS support
gem 'rack-cors'

# Authentication
gem 'devise'
gem 'omniauth-mlh', '~> 0.4.2'
gem 'doorkeeper', '~> 5.7'
gem 'devise-doorkeeper'
gem 'omniauth-rails_csrf_protection'

# User uploads
gem "aws-sdk-s3", require: false
gem "file_validators"

# Templating utilities
gem 'haml-rails'
gem 'simple_form', '~> 5.3.1'

gem 'roadie-rails'
gem 'chartkick', '~> 5.0'
gem 'groupdate'
gem 'font-awesome-rails', '~> 4.7' # needed for icon helpers
gem 'mustache'

# Assets
gem 'sprockets'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'selectize-rails'
gem 'bootstrap', '~> 4.6.0'
gem 'fullcalendar-rails'
gem 'momentjs-rails'

# Markdown parsing
gem 'redcarpet'

# Model extensions
gem 'strip_attributes'
gem 'validate_url'
gem 'audited'

# Background job processing
gem 'sidekiq'
gem "sidekiq-cron"

# Misc support gems
gem 'rails-settings-cached', '~> 2.9.0'
gem 'blazer'
gem 'simple_spark'
gem 'sendgrid-actionmailer'
gem 'httparty'
gem 'rollbar', '~> 3.5'
gem 'rubyzip', '>= 1.3.0'
gem 'rails_12factor', group: :production

gem 'pagy'
gem 'pg_search'
gem 'ransack'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'dotenv-rails'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'guard'
  gem 'guard-minitest'
  gem 'simplecov', require: false
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.10'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.1.0'
  gem 'faker'
end

group :test do
  gem 'test-unit', '~> 3.6'
  gem 'shoulda', '~> 4.0.0'
  gem 'shoulda-matchers', '~> 4.5.1'
  gem 'minitest-reporters'
  gem 'valid_attribute'
  gem 'factory_bot_rails', '~> 6.4.3'
  gem 'codeclimate-test-reporter', '~> 1.0.7', require: nil
  gem 'rails-controller-testing' # Rails 4 fallback
  gem 'webmock', '~> 3.23'
  gem 'timecop'

  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
