require 'dsda_client/models/base'

module DsdaClient
  module Models
    class PlayerUpdate < DsdaClient::Models::Base
      require_keys 'id'
      allow_keys 'username', 'name', 'cheater', 'alias', 'twitch', 'youtube'
    end
  end
end
