ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
if Rails.env.production?
  abort('The Rails environment is running in production mode!')
end
require 'spec_helper'
require 'rspec/rails'
require 'database_cleaner'
# require 'devise'

ActiveRecord::Migration.maintain_test_schema!
Capybara.javascript_driver = :webkit

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
   config.include Warden::Test::Helpers
  # config.include Devise::Test::ControllerHelpers, type: :controller

  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.before :suite do
    # Warden.test_mode!
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
