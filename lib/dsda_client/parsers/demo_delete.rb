require 'dsda_client/parsers/base'

module DsdaClient
  module Parsers
    class DemoDelete < Base
      private

      def model
        'demo_delete'
      end

      def uri
        URI(root_uri + '/demos')
      end

      def make_request
        RequestService.new(method: :delete).request(uri, headers, payload)
      end
    end
  end
end
