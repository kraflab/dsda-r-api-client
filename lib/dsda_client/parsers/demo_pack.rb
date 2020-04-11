require 'dsda_client/parsers/base'

module DsdaClient
  module Parsers
    class DemoPack < Base
      private

      def model
        'demo_pack'
      end

      def uri
        URI(root_uri + '/demos')
      end

      def make_request
        instance['demos'].each do |demo|
          merge_file_data(demo)
          post(demo)
        end
      end

      def post(demo)
        response = make_individual_request(demo)
        if response['save']
          @file_id = response['demo']['file_id']
        end
      end

      def make_individual_request(demo)
        RequestService.new.request(uri, headers, 'demo' => demo)
      end

      def merge_file_data(demo)
        demo.delete('file')
        demo.delete('file_id')

        if @file_id
          demo['file_id'] = @file_id
        else
          demo['file'] = instance['file']
        end
      end
    end
  end
end
