require 'pry'
require 'extensions'
require 'dsda_client/terminal'

ENV['DSDA_API_USERNAME'] = 'test_user'
ENV['DSDA_API_PASSWORD'] = 'password'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.order = :random
  Kernel.srand config.seed

  DsdaClient::Terminal.send_output_to_null
end
