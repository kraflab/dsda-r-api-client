require 'dsda_client/parsers/base'

module DsdaClient
  module Parsers
    class Wad < Base
      private

      def model
        'wad'
      end
    end
  end
end
