require 'net/http'
require 'json'
require 'dsda_client/terminal'
require 'extensions'

module DsdaClient
  class RequestService
    CONTENT_TYPE = 'application/json'.freeze

    def initialize(options)
      @options = options
    end

    def request(uri, headers, body)
      response = make_request(uri, headers, body)
      return request_failure(response, body) unless response.is_a? Net::HTTPSuccess
      request_success(response, body)
    end

    private

    def terminal
      DsdaClient::Terminal
    end

    def response_error(response_hash, original)
      terminal.error("Error: #{response_hash['error_message']}")
      terminal.log_error(original)
    end

    def request_success(response, original)
      response_hash = JSON.parse(response.body)
      terminal.bracket_success('SUCCESS')
      terminal.pretty_json(response_hash.except('error', 'error_message'))
      return response_error(response_hash, original) if response_hash['error']
      terminal.success('Success!')
    end

    def request_failure(response, original)
      terminal.bracket_error('FAIL')
      terminal.error("Error: #{response.code}")
      terminal.log_error(original)
    end

    def make_request(uri, headers, body)
      terminal.print("Issuing request... ")
      request = initialize_request(uri, headers, body)
      Net::HTTP.start(uri.hostname, uri.port, use_ssl: @options.production?) do |http|
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
      @options.post? ? Net::HTTP::Post.new(uri) : Net::HTTP::Get.new(uri)
    end

    def merge_into_header(req, headers)
      headers.each do |k, v|
        req[k] = v
      end
    end
  end
end
