require 'optparse'

module DsdaClient
  class Options
    def initialize
      @dump_requests = false
    end

    def dump_requests?
      @dump_requests
    end

    def dump_requests_option(parser)
      parser.on('--dump-requests', 'Dump requests to stdout instead of sending them.') do
        @dump_requests = true
      end
    end

    def parse_options
      options = {}
      OptionParser.new do |parser|
        parser.banner = "Usage: dsda-client.rb [options]"
        dump_requests_option(parser)
      end
    end
  end
end
