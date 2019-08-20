require 'dsda_client/parsers/base'

module DsdaClient
  module Parsers
    class DemoUpdate < Base
      private

      def model
        'demo_update'
      end

      def uri
        URI(root_uri + '/demos')
      end

      def make_request
        RequestService.new(options, method: :patch).request(uri, headers, payload)
      end
    end
  end
end
