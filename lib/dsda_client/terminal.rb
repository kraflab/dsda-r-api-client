require 'json'

module DsdaClient
  class Terminal
    SUCCESS_CODE = "\e[32m".freeze
    ERROR_CODE = "\e[31m".freeze
    END_CODE = "\e[0m".freeze

    class << self
      def run(command_parser, input)
        data_hash = JSON.parse(input)
        command_parser.parse(data_hash)
      end

      def success(msg)
        stdout.puts success_colorize(msg)
      end

      def error(msg)
        stdout.puts error_colorize(msg)
      end

      def log_error(obj)
        stdout.puts 'Failure logged to failed_uploads.json!'
        prune_raw_data!(obj)
        stderr.puts JSON.pretty_generate(obj)
      end

      def bracket_success(msg)
        stdout.puts "[ #{success_colorize(msg)} ]"
      end

      def bracket_error(msg)
        stdout.puts "[ #{error_colorize(msg)} ]"
      end

      def pretty_json(hash)
        stdout.puts JSON.pretty_generate(hash).gsub(/"/,'')
      end

      def print(msg)
        stdout.print(msg)
      end

      def send_output_to_null
        @stdout = File.open(File::NULL, "w")
        @stderr = File.open(File::NULL, "w")
      end

      private

      def stdout
        @stdout ||= $stdout
      end

      def stderr
        @stderr ||= File.open('failed_uploads.json', 'w')
      end

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

      def colorize(str, color)
        "#{color}#{str}#{END_CODE}"
      end

      def error_colorize(str)
        colorize(str, ERROR_CODE)
      end

      def success_colorize(str)
        colorize(str, SUCCESS_CODE)
      end
    end
  end
end
