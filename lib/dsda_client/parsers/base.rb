require 'base64'
require 'cgi'
require 'dsda_client/request_service'

module DsdaClient
  module Parsers
    class Base
      def self.call(instance, root_uri, headers)
        new(instance, root_uri, headers).call
      end

      def initialize(instance, root_uri, headers)
        @instance = instance
        @root_uri = root_uri
        @headers = headers
      end

      def call
        return track(:invalid,  model, instance) if instance_invalid?
        return track(:bad_file, model, instance) unless parse_file_data
        return track(:dump,     model, instance) if Options.dump_requests?

        make_request
      end

      private

      attr_reader :instance, :headers, :root_uri

      def model
        'base'
      end

      def uri
        URI(root_uri + "/#{model}s/")
      end

      def payload
        { model => instance }
      end

      def make_request
        RequestService.new.request(uri, headers, payload)
      end

      def parse_file_data
        return true if instance['file'].nil?
        file_name = instance['file']['name']
        return false if file_name.nil? || !File.file?(file_name)
        instance['file'] = {
          name: file_name.split('/').last,
          data: Base64.encode64(File.open(file_name, 'rb').read)
        }
        true
      end

      def instance_invalid?
        "DsdaClient::Models::#{model.camelize}".constantize.invalid?(instance)
      end

      def track(*args)
        DsdaClient::IncidentTracker.track(*args)
      end
    end
  end
end
