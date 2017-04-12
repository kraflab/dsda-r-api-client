#!/usr/bin/env ruby

require 'net/http'
require 'json'
require 'cgi'
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
    when 'wad', 'player'
      parse_commands(args, request_hash, root_uri, "#{target}s")
    when nil
      puts error_color("Missing 'get' target")
    else
      puts error_color("Unknown target '#{target}'")
    end
  when 'post'
    case target = args.shift
    when 'demo'
      request_hash[:username] = ENV["DSDA_API_USERNAME"]
      request_hash[:password] = ENV["DSDA_API_PASSWORD"]
      parse_commands(args,request_hash, root_uri, "#{target}s")
    when nil
      puts error_color("Missing 'post' target")
    else
      puts error_color("Unknown target '#{target}'")
    end
  when nil
  else
    puts error_color("Unknown request type '#{req}'")
  end
end
