require 'base64'
require 'cgi'
require 'active_support/inflector'
require 'dsda_client/request_service'
require 'dsda_client/api'
require 'dsda_client/terminal'
require 'dsda_client/incident_tracker'
require 'dsda_client/models'

module DsdaClient
  class CommandParser
    ALLOWED_MODELS = %w[demo wad player port demo_pack].freeze

    def initialize(root_uri, options)
      @root_uri = root_uri
      @options = options
    end

    def parse(data_hash)
      generate_request_hash
      data_hash.each do |model, batch|
        model = model.singularize
        next if unknown_model?(model, batch)
        parse_batch(model, batch)
      end
    end

    private

    def generate_request_hash
      @request_hash = {}
      merge_api_credentials if @options.post?
    end

    def unknown_model?(model, batch)
      return false if ALLOWED_MODELS.include?(model)
      DsdaClient::Terminal.error("Unknown model '#{model}'")
      DsdaClient::IncidentTracker.track(:unknown_model, model, batch)
      true
    end

    def parse_batch(model, batch)
      batch = arrayify(batch)
      batch.each do |instance|
        parse_instance(instance, model)
      end
    end

    def merge_api_credentials
      @request_hash['API-USERNAME'] = DsdaClient::Api.username
      @request_hash['API-PASSWORD'] = DsdaClient::Api.password
    end

    def parse_file_data(instance)
      return true if instance['file'].nil?
      file_name = instance['file']['name']
      return false if file_name.nil? || !File.file?(file_name)
      instance['file'] = {
        name: file_name.split('/').last,
        data: Base64.encode64(File.open(file_name, 'rb').read)
      }
      true
    end

    def instance_invalid?(instance, model)
      "DsdaClient::Models::#{model.capitalize}".constantize.invalid?(instance)
    end

    def parse_instance(instance, model)
      return track(:invalid,  model, instance) if instance_invalid?(instance, model)
      return track(:bad_file, model, instance) unless parse_file_data(instance)
      return track(:dump,     model, instance) if @options.dump_requests?

      uri = URI(@root_uri + "/#{model}s/")
      RequestService.new(@options).request(uri, @request_hash, { model => instance})
    end

    def arrayify(batch)
      batch.is_a?(Array) ? batch : [batch]
    end

    def track(*args)
      DsdaClient::IncidentTracker.track(*args)
    end
  end
end
