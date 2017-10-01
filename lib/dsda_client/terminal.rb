require 'lib/dsda_client/api'

module DsdaClient
  class Terminal
    class << self
      def run(command_parser)
        print_opening_info
        while (input = prompt) !~ /(exit)|(quit)/
          args = input.scan(/".*?"|[^\s"]+/).collect { |i| i.gsub(/"/, '') }
          request_hash = {}
          case req = args.shift
          when 'get'
            case target = args.shift
            when 'wad', 'player'
              command_parser.parse(args, request_hash, "#{target}s", input)
            when nil
              error("Missing 'get' target")
            else
            error("Unknown target '#{target}'")
            end
          when 'post'
            request_hash['API-USERNAME'] = DsdaClient::Api.username
            request_hash['API-PASSWORD'] = DsdaClient::Api.password
            case target = args.shift
            when 'demo', 'wad', 'player', 'port'
              command_parser.parse(args, request_hash, "#{target}s", input)
            when nil
              error("Missing 'post' target")
            else
              error("Unknown target '#{target}'")
            end
          when nil
          else
            error("Unknown request type '#{req}'")
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

      def error(msg)
        puts error_colorize(msg)
      end

      private

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
