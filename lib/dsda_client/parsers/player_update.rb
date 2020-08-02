require 'dsda_client/parsers/base'

module DsdaClient
  module Parsers
    class PlayerUpdate < Base
      private

      def model
        'player_update'
      end

      def uri
        URI(root_uri + "/players/#{instance['id']}")
      end

      def make_request
        RequestService.new(method: :patch).request(uri, headers, payload)
      end
    end
  end
end
