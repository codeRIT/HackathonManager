ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../test/dummy/config/environment.rb', __dir__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path('../test/dummy/db/migrate', __dir__)]

if ["manual", "travis"].include?(ENV["RUN_COVERAGE"])
  require 'simplecov'
  require 'codeclimate-test-reporter' if ENV["RUN_COVERAGE"] == "travis"
  SimpleCov.add_filter 'vendor/'
  SimpleCov.add_filter 'app/mailers/mail_preview.rb'
  if ENV["RUN_COVERAGE"] == "travis"
    SimpleCov.formatters = []
    SimpleCov.start CodeClimate::TestReporter.configuration.profile
  else
    SimpleCov.start 'rails'
  end
end

require "rails/test_help"
require "strip_attributes/matchers"
require "minitest/reporters"
require "valid_attribute"
require "factory_bot_rails"
require "sidekiq/testing"
require "paperclip/matchers"
require "webmock/minitest"

if defined?(RUBY_ENGINE) && RUBY_ENGINE == "ruby" && RUBY_VERSION >= "1.9"
  module Kernel
    alias __at_exit at_exit
    def at_exit
      __at_exit do
        exit_status = $ERROR_INFO.status if $ERROR_INFO.is_a?(SystemExit)
        yield
        exit exit_status if exit_status
      end
    end
  end
end

Minitest::Reporters.use!
if ENV["RUN_COVERAGE"] == "travis"
  Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new(color: true)]
end

FactoryBot.reload

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path('fixtures', __dir__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + "/files"
  ActiveSupport::TestCase.fixtures :all
end

# Factories are already imported through a Rails Engine initializer - don't re-import them here
# FactoryBot.definition_file_paths << File.join(File.dirname(__FILE__), 'factories')
# FactoryBot.find_definitions

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Uncomment for awesome colorful output
# require "minitest/pride"

def sample_file(filename = "sample_pdf.pdf")
  File.new("test/fixtures/#{filename}")
end

# Clean up Paperclip uploads generated during tests
Minitest.after_run do
  FileUtils.rm_rf(Dir["#{Rails.root}/public/system/"])
end

class ActiveSupport::TestCase
  extend StripAttributes::Matchers
  include ValidAttribute::Method
  include FactoryBot::Syntax::Methods
  extend Paperclip::Shoulda::Matchers

  # Add more helper methods to be used by all tests here...
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end
