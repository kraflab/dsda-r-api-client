require 'dsda_client/models/base'

module DsdaClient
  module Models
    class Port < DsdaClient::Models::Base
      require_keys 'family', 'version', 'file'
    end
  end
end
