require 'dsda_client/parsers/base'

module DsdaClient
  module Parsers
    class Otp < Base
      private

      def model
        'otp'
      end

      def uri
        URI(root_uri + "/otp")
      end

      def make_request
        RequestService.new(method: :post).request(uri, headers, payload)
      end
    end
  end
end
