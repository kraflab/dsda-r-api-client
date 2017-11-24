require 'dsda_client/models/base'

module DsdaClient
  module Models
    class Demo < DsdaClient::Models::Base
      require_keys 'tas', 'guys', 'version', 'wad_username', 'file', 'engine',
                   'time', 'level', 'levelstat', 'category_name', 'recorded_at',
                   'players'
      allow_keys   'tags', 'compatibility', 'video_link'
    end
  end
end
