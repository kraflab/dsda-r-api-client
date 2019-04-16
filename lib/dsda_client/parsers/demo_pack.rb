require 'dsda_client/parsers/base'

module DsdaClient
  module Parsers
    class DemoPack < Base
      private

      def model
        'demo_pack'
      end
    end
  end
end
