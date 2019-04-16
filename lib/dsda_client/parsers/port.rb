require 'dsda_client/parsers/base'

module DsdaClient
  module Parsers
    class Port < Base
      private

      def model
        'port'
      end
    end
  end
end
