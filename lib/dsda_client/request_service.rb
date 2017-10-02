require 'net/http'
require 'json'
require 'dsda_client/terminal'
require 'extensions'

module DsdaClient
  class RequestService
    def request(uri, query, body, request_type, original)
      print "Issuing #{request_type.upcase} request... "

      # set api query header
      req = case request_type
      when :post
        Net::HTTP::Post.new(uri)
      else
        Net::HTTP::Get.new(uri)
      end
      query.each do |k, v|
        req[k] = v
      end
      req.body = body.to_json
      req.content_type = 'application/json'
      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) {|http|
        http.request(req)
      }

      if res.is_a? Net::HTTPSuccess
        DsdaClient::Terminal.bracket_success('SUCCESS')
        res_hash = JSON.parse(res.body)
        puts JSON.pretty_generate(res_hash.except('error', 'error_message')).gsub(/"/,'')
        if res_hash['error']
          DsdaClient::Terminal.error("Error: #{res_hash['error_message']}")
          STDERR.puts original
        else
          DsdaClient::Terminal.success('Success!')
        end
      else
        DsdaClient::Terminal.bracket_error('FAIL')
        DsdaClient::Terminal.error("Error: #{res.code}")
        STDERR.puts original
      end
    end
  end
end
