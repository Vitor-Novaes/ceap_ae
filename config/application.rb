require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ceap
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.autoload_paths << Rails.root.join('lib')
    config.active_job.queue_adapter = :sidekiq
    config.session_store :cookie_store, key: '_interslice_session'

    config.time_zone = 'America/Sao_Paulo'

    config.api_only = true
  end
end
