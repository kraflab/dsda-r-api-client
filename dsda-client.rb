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
  request_hash = {}
  case req = args.shift
  when 'get'
    case target = args.shift
    when 'wad'
      case id = args.shift
      when nil
        puts error_color("Missing 'get wad' id")
      else
        error = false
        commands = split_array(args, ';')
        uri = URI(root_uri + "/wads/#{id}")
        commands.each do |command|
          case command.shift
          when 'record'
            level = command.shift
            category = command.shift
            if level and category
              request_hash[:record] = {level: level, category: category}
            else
              puts error_color("Missing record details: 'level' and 'category'")
              error = true
            end
          when 'count'
            model = command.shift
            if model
              request_hash[:count] ||= []
              request_hash[:count].push model
            else
              puts error_color("Missing count detail: 'model'")
              error = true
            end
          else
            request_hash[:properties] = 'all'
          end
        end
        unless error
          params = {query: request_hash.to_json}
          uri.query = URI.encode_www_form(params)
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
    puts error_color("Unknown request type '#{req}'")
  end
end
