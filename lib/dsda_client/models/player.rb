require 'dsda_client/models/base'

module DsdaClient
  module Models
    class Player < DsdaClient::Models::Base
      require_keys 'name'
      allow_keys 'username'
    end
  end
end
