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

    def request(uri, query, body)
      response = make_request(uri, query, body)
      if response.is_a? Net::HTTPSuccess
        request_success(response, body)
      else
        request_failure(body)
      end
    end

    private

    def response_error(response_hash, original)
      DsdaClient::Terminal.error("Error: #{response_hash['error_message']}")
      DsdaClient::Terminal.log_error(original)
    end

    def request_success(response, original)
      response_hash = JSON.parse(response.body)
      DsdaClient::Terminal.bracket_success('SUCCESS')
      DsdaClient::Terminal.pretty_json(response_hash.except('error', 'error_message'))
      if response_hash['error']
        response_error(response_hash, original)
      else
        DsdaClient::Terminal.success('Success!')
      end
    end

    def request_failure(original)
      DsdaClient::Terminal.bracket_error('FAIL')
      DsdaClient::Terminal.error("Error: #{response.code}")
      DsdaClient::Terminal.log_error(original)
    end

    def make_request(uri, query, body)
      print "Issuing request... "
      request = request_for_uri(uri)
      merge_into_header(request, query)
      request.body = body.to_json
      request.content_type = CONTENT_TYPE
      Net::HTTP.start(uri.hostname, uri.port, use_ssl: @options.production?) do |http|
        http.request(request)
      end
    end

    def request_for_uri(uri)
      if @options.post?
        Net::HTTP::Post.new(uri)
      else
        Net::HTTP::Get.new(uri)
      end
    end

    def merge_into_header(req, query)
      query.each do |k, v|
        req[k] = v
      end
    end
  end
end
