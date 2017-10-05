require 'json'
require 'dsda_client/api'

module DsdaClient
  class Terminal
    ALLOWED_MODELS = %w[demo wad player port].freeze

    class << self
      def run(command_parser, options)
        request_hash = {}
        merge_api_credentials(request_hash) if options.post?
        entire_hash = JSON.parse(ARGF.read)
        entire_hash.each do |model, batch|
          make_singular(model)
          if !ALLOWED_MODELS.include?(model)
            error("Unknown model '#{model}'")
          else
            batch = arrayify(batch)
            batch.each do |instance|
              command_parser.parse(instance, request_hash, model)
            end
          end
        end
      end

      def success(msg)
        puts success_colorize(msg)
      end

      def error(msg)
        puts error_colorize(msg)
      end

      def log_error(obj)
        prune_raw_data!(obj)
        STDERR.puts JSON.pretty_generate(obj)
      end

      def bracket_success(msg)
        puts "[ #{success_colorize(msg)} ]"
      end

      def bracket_error(msg)
        puts "[ #{error_colorize(msg)} ]"
      end

      def pretty_json(hash)
        puts JSON.pretty_generate(hash).gsub(/"/,'')
      end

      private

      def prune_raw_data!(obj)
        if obj.is_a?(Hash)
          obj[:data] = '[pruned]' if obj[:data]
        end
        if obj.is_a?(Enumerable)
          obj.each do |element|
            prune_raw_data!(element)
          end
        end
      end

      def make_singular(model)
        if model.is_a?(String) && model.length > 1 && model[-1] == 's'
          model = model.slice(0, model.length - 1)
        end
      end

      def arrayify(batch)
        batch.is_a?(Array) ? batch : [batch]
      end

      def merge_api_credentials(request_hash)
        request_hash['API-USERNAME'] = DsdaClient::Api.username
        request_hash['API-PASSWORD'] = DsdaClient::Api.password
      end

      def colorize(str, color)
        "#{color}#{str}\e[0m"
      end

      def error_colorize(str)
        colorize(str, "\e[31m")
      end

      def success_colorize(str)
        colorize(str, "\e[32m")
      end
    end
  end
end
