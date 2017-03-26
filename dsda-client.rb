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
      parse_wad(args, request_hash, root_uri)
    when 'player'
      parse_player(args, request_hash, root_uri)
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
