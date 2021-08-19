source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Use Ruby version defined in .ruby-version
ruby '>= 2.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4.4'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
# Use Puma as the app server
gem 'puma', '~> 5.2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# CORS support
gem 'rack-cors'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Authentication
gem 'devise', '~> 4.7'
gem 'omniauth-mlh', '~> 0.4.2'
gem 'doorkeeper', '~> 5.5'
gem 'devise-doorkeeper'
gem 'omniauth-rails_csrf_protection'

# User uploads
gem "aws-sdk-s3", require: false
gem "file_validators"

# Templating utilities
gem 'haml-rails', '~> 2.0'
gem 'simple_form'
gem 'ajax-datatables-rails', '~> 1.0'
gem 'roadie-rails'
gem 'chartkick', '~> 3.4'
gem 'groupdate'
gem 'font-awesome-rails', '~> 4.7' # needed for icon helpers
gem 'mustache', '~> 1.0'

# Assets
gem 'sprockets'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'selectize-rails'
gem 'highcharts-rails', '~> 6.0'
gem 'bootstrap', '~> 4.6.0'
gem 'fullcalendar-rails'
gem 'momentjs-rails'

# Markdown parsing
gem 'redcarpet'

# Model extensions
gem 'strip_attributes'
gem 'validate_url'
gem 'audited', '~> 4.10'

# Background job processing
gem 'sidekiq', '< 7'
gem 'sidekiq-cron', github: 'codeRIT/sidekiq-cron', branch: 'master'

# Misc support gems
gem 'rails-settings-cached', '~> 0.7.2'
gem 'blazer'
gem 'simple_spark'
gem 'sendgrid-actionmailer'
gem 'httparty'
gem 'rollbar', '~> 3.1'
gem 'rubyzip', '>= 1.3.0'
gem 'rails_12factor', group: :production

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
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # API documentation
  gem 'yard'
end

group :test do
  gem 'test-unit', '~> 3.4'
  gem 'shoulda', '~> 4.0.0'
  gem 'shoulda-matchers', '~> 4.5.1'
  gem 'minitest-reporters'
  gem 'valid_attribute'
  gem 'factory_bot_rails'
  gem 'codeclimate-test-reporter', '~> 1.0.7', require: nil
  gem 'rails-controller-testing' # Rails 4 fallback
  gem 'webmock', '~> 3.12'
  gem 'timecop'

  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
