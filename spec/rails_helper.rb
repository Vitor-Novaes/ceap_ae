require 'simplecov'

SimpleCov.start :rails do
  add_filter do |source_file|
    source_file.lines.count < 5
  end
end

ENV['RAILS_ENV'] ||= 'test'

# Add additional requires below this line. Rails is not loaded until this point!
require File.expand_path('../../config/environment', __FILE__)

# Prevent database truncation if the environment is production
abort("The Rails is running in #{Rails.env}! Should be test!") unless Rails.env.test?

# Loads rails
require 'spec_helper'
require 'rspec/rails'
require 'rspec/json_expectations'
require 'factory_bot'
require 'faker'
require 'database_cleaner'
require 'webmock/rspec'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false


  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end
