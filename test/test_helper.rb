ENV['RAILS_ENV'] ||= 'test'

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

# This must be AFTER SimpleCov is required, or it won't work
require_relative '../config/environment'
require 'rails/test_help'

require "strip_attributes/matchers"
require "minitest/reporters"
require "valid_attribute"
require "factory_bot_rails"
require "sidekiq/testing"
require "webmock/minitest"
require_relative './matchers'

Minitest::Reporters.use! unless ENV['RM_INFO']

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
  extend HackathonManager::Shoulda::Matchers

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :minitest
    with.library :rails
  end
end
