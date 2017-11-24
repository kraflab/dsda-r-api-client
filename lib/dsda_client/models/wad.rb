require 'dsda_client/models/base'

module DsdaClient
  module Models
    class Wad < DsdaClient::Models::Base
      require_keys 'author', 'iwad', 'name', 'username'
      allow_keys   'file', 'single_map', 'year'
    end
  end
end
