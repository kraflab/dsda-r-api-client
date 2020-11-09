require 'dsda_client/models/base'

module DsdaClient
  module Models
    class Wad < DsdaClient::Models::Base
      require_keys 'author', 'iwad', 'name', 'short_name'
      allow_keys   'file', 'single_map', 'year', 'parent'
    end
  end
end
