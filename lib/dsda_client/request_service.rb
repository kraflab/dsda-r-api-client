require 'net/http'
require 'json'
require 'lib/dsda_client/terminal'
require 'lib/extensions'

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
        puts '[ ' + success_color('SUCCESS') + ' ]'
        res_hash = JSON.parse(res.body)
        puts JSON.pretty_generate(res_hash.except('error', 'error_message')).gsub(/"/,'')
        if res_hash['error']
          puts error_color("Error: #{res_hash['error_message']}")
          STDERR.puts original
        else
          puts success_color("Success!")
        end
      else
        puts '[ ' + error_color('FAIL') + ' ]'
        puts error_color("Error: #{res.code}")
        STDERR.puts original
      end
    end
  end
end
