require 'net/http'
require 'json'
require 'dsda_client/terminal'
require 'extensions'

module DsdaClient
  class RequestService
    def request(uri, query, body, action, original)
      print "Issuing #{action.upcase} request... "

      request = request_for_action(action, uri)
      merge_into_header(request, query)
      request.body = body.to_json
      request.content_type = 'application/json'
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end

      if response.is_a? Net::HTTPSuccess
        DsdaClient::Terminal.bracket_success('SUCCESS')
        response_hash = JSON.parse(response.body)
        puts JSON.pretty_generate(response_hash.except('error', 'error_message')).gsub(/"/,'')
        if response_hash['error']
          DsdaClient::Terminal.error("Error: #{response_hash['error_message']}")
          STDERR.puts original
        else
          DsdaClient::Terminal.success('Success!')
        end
      else
        DsdaClient::Terminal.bracket_error('FAIL')
        DsdaClient::Terminal.error("Error: #{response.code}")
        STDERR.puts original
      end
    end

    private

    def request_for_action(action, uri)
      case action
      when :post
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
