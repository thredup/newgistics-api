require "bundler/setup"
require "newgistics_api"
require "vcr"
require "yaml"

API_CREDENTIALS_FILEPATH = File.join(File.dirname(__FILE__), 'api_credentials.yml')

if File.exist?(API_CREDENTIALS_FILEPATH)
  api_credentials = YAML.load_file(API_CREDENTIALS_FILEPATH)
else
  api_credentials = YAML.load_file("#{API_CREDENTIALS_FILEPATH}.sample")
end

NewgisticsApi.configure do |config|
  config.api_key = api_credentials["api_key"]
  config.host = api_credentials["host"]
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = false
  config.filter_sensitive_data('<API_KEY>') { NewgisticsApi.configuration.api_key }
  config.filter_sensitive_data('https://host') { NewgisticsApi.configuration.host }
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
