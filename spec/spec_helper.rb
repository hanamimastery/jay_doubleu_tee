require "bundler/setup"
require "jay_doubleu_tee"

# Enable test interface for dry-configurable
require "dry/configurable/test_interface"
module JayDoubleuTee
  enable_test_interface
end

RSpec.configure do |config|
  config.before(:each) { JayDoubleuTee.reset_config }

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
