# frozen_string_literal: true

require "bundler/setup"
require "webmock/rspec"
require "grist"

RSpec.configure do |config|
  WebMock.allow_net_connect!
  WebMock.disable!
  
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
