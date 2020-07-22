require 'dsda_client/models/base'

module DsdaClient
  module Models
    class Demo < DsdaClient::Models::Base
      require_keys 'tas', 'guys', 'version', 'wad', 'file', 'engine',
                   'time', 'level', 'levelstat', 'category', 'recorded_at',
                   'players', 'solo_net'
      allow_keys   'tags', 'compatibility', 'video_link', 'kills', 'items',
                   'secrets', 'suspect', 'cheated', 'secret_exit'
    end
  end
end
