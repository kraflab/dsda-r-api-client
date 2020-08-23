require 'active_support/inflector'
require 'dsda_client/api'
require 'dsda_client/terminal'
require 'dsda_client/incident_tracker'
require 'dsda_client/models'
require 'dsda_client/parsers'

module DsdaClient
  class CommandParser
    ALLOWED_MODELS = %w[demo wad wad_update player player_update merge_player port demo_pack demo_update].freeze

    def initialize(root_uri)
      @root_uri = root_uri
    end

    def parse(data_hash)
      fill_headers
      data_hash.each do |model, batch|
        model = model.singularize
        next if unknown_model?(model, batch)
        parse_batch(model, batch)
      end
    end

    private

    def parse_batch(model, batch)
      arrayify(batch).each do |instance|
        parse_instance(instance, model)
      end
    end

    def parser(model)
      "DsdaClient::Parsers::#{model.camelize}".constantize
    end

    def parse_instance(instance, model)
      parser(model).call(instance, @root_uri, @headers)
    end

    def unknown_model?(model, batch)
      return false if ALLOWED_MODELS.include?(model)
      DsdaClient::Terminal.error("Unknown model '#{model}'")
      DsdaClient::IncidentTracker.track(:unknown_model, model, batch)
      true
    end

    def fill_headers
      @headers = {}
      merge_api_credentials
    end

    def merge_api_credentials
      @headers['Authorization'] = "Bearer #{DsdaClient::Api.token}"
    end

    def arrayify(object)
      object.is_a?(Array) ? object : [object]
    end
  end
end
