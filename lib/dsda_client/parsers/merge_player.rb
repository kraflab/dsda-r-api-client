require 'dsda_client/parsers/base'

module DsdaClient
  module Parsers
    class MergePlayer < Base
      private

      def model
        'merge_players'
      end

      def uri
        URI(root_uri + "/merge_players")
      end

      def make_request
        RequestService.new(method: :post).request(uri, headers, payload)
      end
    end
  end
end
