require 'dsda_client/models/base'

module DsdaClient
  module Models
    class Demo < DsdaClient::Models::Base
      require_keys 'tas', 'guys', 'version', 'wad', 'engine',
                   'time', 'level', 'levelstat', 'category', 'recorded_at',
                   'players', 'solo_net', ['file', 'file_id']
      allow_keys   'tags', 'compatibility', 'video_link', 'kills', 'items',
                   'secrets', 'suspect', 'cheated', 'secret_exit'
    end
  end
end
