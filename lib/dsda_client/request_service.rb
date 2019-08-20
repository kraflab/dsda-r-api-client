require 'net/http'
require 'json'
require 'dsda_client/terminal'
require 'extensions'

module DsdaClient
  class RequestService
    CONTENT_TYPE = 'application/json'.freeze

    def initialize(options, method: :post)
      @options = options
      @method = method
    end

    def request(uri, headers, request_body)
      make_request(uri, headers, request_body)
      handle_response(request_body)
      response_hash
    end

    private

    def handle_response(request_body)
      if @response.code =~ /^2/
        request_success(request_body)
      else
        request_failure(request_body)
      end
    end

    def response_hash
      @response_hash ||= JSON.parse(@response.body)
    end

    def terminal
      DsdaClient::Terminal
    end

    def response_error(request_body)
      terminal.error("Error: #{response_hash['error_message']}")
      report_error(request_body)
    end

    def request_success(request_body)
      terminal.bracket_success('SUCCESS')
      terminal.pretty_json(response_hash.except('error', 'error_message'))
      return response_error(request_body) if response_hash['error']
      terminal.success('Success!')
    end

    def request_failure(request_body)
      terminal.bracket_error('FAIL')
      terminal.error("Error: #{@response.code}")
      report_error(request_body)
    end

    def make_request(uri, headers, body)
      terminal.print("Issuing request... ")
      request = initialize_request(uri, headers, body)
      @response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: @options.production?) do |http|
        http.request(request)
      end
    end

    def initialize_request(uri, headers, body)
      request = request_for_uri(uri)
      merge_into_header(request, headers)
      request.body = body.to_json
      request.content_type = CONTENT_TYPE
      request
    end

    def request_for_uri(uri)
      @method == :post ? Net::HTTP::Post.new(uri) : Net::HTTP::Patch.new(uri)
    end

    def merge_into_header(req, headers)
      headers.each do |k, v|
        req[k] = v
      end
    end

    def report_error(request_body)
      terminal.report_failure
      terminal.log_error(request_body)
      terminal.log_error(response_hash)
    end
  end
end
