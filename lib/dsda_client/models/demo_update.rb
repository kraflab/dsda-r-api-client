require 'dsda_client/models/base'

module DsdaClient
  module Models
    class DemoUpdate < DsdaClient::Models::Base
      require_keys 'match_details'
      allow_keys   'tas', 'guys', 'version', 'wad', 'engine', 'time', 'level',
                   'levelstat', 'category', 'recorded_at', 'players',
                   'solo_net', 'compatibility', 'video_link', 'kills', 'items',
                   'secrets', 'tags'
    end
  end
end
