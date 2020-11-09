require 'dsda_client/models/base'

module DsdaClient
  module Models
    class WadUpdate < DsdaClient::Models::Base
      require_keys 'id'
      allow_keys   'file', 'single_map', 'year', 'author', 'iwad', 'name',
                   'short_name', 'parent'
    end
  end
end
