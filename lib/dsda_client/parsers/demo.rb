require 'dsda_client/parsers/base'

module DsdaClient
  module Parsers
    class Demo < Base
      private

      def model
        'demo'
      end
    end
  end
end
