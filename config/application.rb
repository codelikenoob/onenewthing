require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Onenewthing
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework :rspec, fixture_replacement: :factory_girl
      g.fixture false
      g.view_specs false
      g.helper_specs false
      g.routing_specs false
      g.request_specs false
    end
  end
end
