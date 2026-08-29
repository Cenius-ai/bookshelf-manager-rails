require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"

Bundler.require(*Rails.groups)

module Work
  class Application < Rails::Application
    config.load_defaults 7.2
    config.autoload_lib(ignore: %w[assets tasks])
    config.generators.system_tests = nil

    # Dev fallback for secret_key_base so the app boots with no env set
    config.secret_key_base = ENV.fetch("SECRET_KEY_BASE") {
      "cenius-dev-3f8a1b7c2e5d4a9f6b0d8e1c3a7f2b4d"
    }
  end
end
