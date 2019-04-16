require 'dsda_client/parsers/base'

module DsdaClient
  module Parsers
    class Player < Base
      private

      def model
        'player'
      end
    end
  end
end
