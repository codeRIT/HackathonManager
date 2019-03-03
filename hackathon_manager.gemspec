$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'hackathon_manager/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'hackathon_manager'
  s.version     = HackathonManager::VERSION
  s.authors     = ['Stuart Olivera']
  s.email       = ['stuart@stuartolivera.com']
  s.homepage    = 'https://github.com/sman591/hackathon_manager'
  s.summary     = 'Full-featured application for managing hackathon logistics'
  s.description = 'Full-featured application for managing hackathon logistics'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib,public,test/factories}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5.1'

  s.add_dependency 'mysql2'

  s.add_dependency 'test-unit', '~> 3.0'

  s.add_dependency 'sidekiq', '< 6'
  s.add_dependency 'sprockets'

  s.add_dependency 'devise', '~> 4.2'
  s.add_dependency 'omniauth-mlh', '~> 0.1'
  s.add_dependency 'doorkeeper', '~> 5.0'
  s.add_dependency 'devise-doorkeeper'

  s.add_dependency 'httparty'

  s.add_dependency 'paperclip', '~> 6.0'
  s.add_dependency 'aws-sdk-s3'

  s.add_dependency 'haml-rails'
  s.add_dependency 'simple_form'
  s.add_dependency 'ajax-datatables-rails', '~> 0.4.0' # Does NOT follow semver
  s.add_dependency 'roadie-rails'
  s.add_dependency 'chartkick', '~> 3.0'
  s.add_dependency 'groupdate'
  s.add_dependency 'font-awesome-rails', '~> 4.0' # needed for icon helpers

  s.add_dependency 'strip_attributes'

  s.add_dependency 'validate_url'

  s.add_dependency 'redcarpet'

  s.add_dependency 'rails-settings-cached', '~> 0.7.2'

  # Previously grouped under assets:
  s.add_dependency 'sass-rails'
  s.add_dependency 'coffee-rails'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'jquery-ui-sass-rails'
  s.add_dependency 'selectize-rails'
  s.add_dependency 'highcharts-rails', '~> 6.0'
  s.add_dependency 'uglifier', '~> 3.0'
  s.add_dependency 'bootstrap', '~> 4.3.1'

  s.add_dependency 'blazer'

  s.add_dependency 'simple_spark'
end
