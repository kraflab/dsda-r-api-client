require 'dsda_client/models/base'

module DsdaClient
  module Models
    class DemoDelete < DsdaClient::Models::Base
      require_keys 'match_details'
      require_otp
    end
  end
end
