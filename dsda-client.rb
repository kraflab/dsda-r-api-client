#!/usr/bin/env ruby

require 'net/http'
require 'json'
require_relative 'lib/extensions'
require_relative 'lib/helper'

# root api address "http://example.com/api"
root_uri = ENV["DSDA_API_LOCATION"]
if root_uri.nil?
  puts error_color("Environment variable DSDA_API_LOCATION not found")
  exit
end

puts "=> Starting DSDA API Client"
puts "=> Using ruby #{RUBY_VERSION}"
puts "=> Type 'exit' or 'quit' to close the client"
while (input = prompt) !~ /(exit)|(quit)/
  args = input.scan(/".*?"|[^\s"]+/).collect { |i| i.gsub(/"/, '') }
  case command = args.shift
  when 'get'
    case target = args.shift
    when 'wad'
      case id = args.shift
      when nil
        puts error_color("Missing 'get wad' id")
      else
        uri = URI(root_uri + "/wads/#{id}")
        case sub_command = args.shift
        when 'record'
          level = args.shift
          category = args.shift
          if level and category
            params = {query: {level: level, category: category}.to_json}
            uri.query = URI.encode_www_form(params)
            do_request(uri)
          else
            puts error_color("Missing record details: 'level' and 'category'")
          end
        else
          do_request(uri)
        end
      end
    when nil
      puts error_color("Missing 'get' target")
    else
      puts error_color("Unknown get target '#{target}'")
    end
  when nil
  else
    puts error_color("Unknown key word '#{command}'")
  end
end
