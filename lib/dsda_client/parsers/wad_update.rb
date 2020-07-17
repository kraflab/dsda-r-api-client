require 'dsda_client/parsers/base'

module DsdaClient
  module Parsers
    class WadUpdate < Base
      private

      def model
        'wad_update'
      end

      def uri
        URI(root_uri + "/wads/#{instance['id']}")
      end

      def make_request
        RequestService.new(method: :patch).request(uri, headers, payload)
      end
    end
  end
end
