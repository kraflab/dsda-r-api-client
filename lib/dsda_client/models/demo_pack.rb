require 'dsda_client/models/base'

module DsdaClient
  module Models
    class DemoPack < DsdaClient::Models::Base
      require_keys 'file', 'demos'
    end
  end
end
