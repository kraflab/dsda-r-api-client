require 'dsda_client/models/base'

module DsdaClient
  module Models
    class MergePlayers < DsdaClient::Models::Base
      require_keys 'from', 'into'
    end
  end
end
