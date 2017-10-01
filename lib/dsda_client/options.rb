require 'optparse'

module DsdaClient
  class Options
    def initialize(args)
      @dump_requests = false
      parse(args)
    end

    def dump_requests?
      @dump_requests
    end

    def dump_requests_option(parser)
      parser.on('--dump-requests', 'Dump requests to stdout instead of sending them') do
        @dump_requests = true
      end
    end

    def help_option(parser)
      parser.on('-h', '--help', 'Print this help') do
        puts parser
        exit
      end
    end

    def parse(args)
      OptionParser.new do |parser|
        parser.banner = "Usage: dsda-client.rb [options]"
        dump_requests_option(parser)
        help_option(parser)
      end.parse!(args)
    end
  end
end
