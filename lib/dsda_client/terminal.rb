require 'json'
require 'dsda_client/api'

module DsdaClient
  class Terminal
    ALLOWED_MODELS = {
      'get'  => %w[wad player],
      'post' => %w[demo wad player port]
    }.freeze

    class << self
      def run(command_parser)
        print_opening_info
        while (input = prompt) !~ /(exit)|(quit)/
          args = input.scan(/".*?"|[^\s"]+/).collect { |i| i.gsub(/"/, '') }
          request_hash = {}
          action = args.shift
          model = args.shift
          if ALLOWED_MODELS[action] && ALLOWED_MODELS[action].include?(model)
            merge_api_credentials(request_hash) if action == 'post'
            command_parser.parse(args, request_hash, model, input)
          elsif ALLOWED_MODELS[action].nil?
            error("Unknown action '#{action}'")
          else
            error("Unknown model '#{model}'")
          end
        end
      end

      def prompt
        print 'dsda-r: '
        # backtrack prompt if input not from command line
        if (str = gets).nil?
          print "\r"
          exit
        else
          str.chomp
        end
      end

      def success(msg)
        puts success_colorize(msg)
      end

      def error(msg)
        puts error_colorize(msg)
      end

      def log_error(msg)
        STDERR.puts msg
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

      def print_opening_info
        puts "=> Starting DSDA API Client"
        puts "=> Using ruby #{RUBY_VERSION}"
        puts "=> Enter 'exit' or 'quit' to close the client"
      end
    end
  end
end
