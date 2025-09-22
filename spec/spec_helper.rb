require "feedback_gem"
require "webmock/rspec"
require "vcr"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Reset configuration before each test
  config.before(:each) do
    FeedbackGem.reset_configuration!
  end
end

# VCR configuration for recording HTTP interactions
VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.default_cassette_options = { record: :once }
  
  # Filter sensitive data
  config.filter_sensitive_data('<CLIENT_ID>') { ENV['TDX_CLIENT_ID'] }
  config.filter_sensitive_data('<CLIENT_SECRET>') { ENV['TDX_CLIENT_SECRET'] }
end
