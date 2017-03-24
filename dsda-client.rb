#!/usr/bin/env ruby

require 'net/http'
require 'json'

class Hash
  # Returns a hash that includes everything but the given keys.
  def except(*keys)
    dup.except!(*keys)
  end

  # Replaces the hash without the given keys.
  def except!(*keys)
    keys.each { |key| delete(key) }
    self
  end
end

# add color to the terminal output
def colorize(str, color)
  "#{color}#{str}\e[0m"
end

def error_color(str)
  colorize(str, "\e[31m")
end

def success_color(str)
  colorize(str, "\e[32m")
end

def prompt
  print 'dsda-r: '
  gets.chomp
end

# submit and parse request given by uri
def do_request(uri)
  print 'Issuing GET request... '
  res = Net::HTTP.get_response(uri)
  if res.is_a? Net::HTTPSuccess
    puts '[ ' + success_color('SUCCESS') + ' ]'
    res_hash = JSON.parse(res.body)
    puts JSON.pretty_generate(res_hash.except('error', 'error_message')).gsub(/"/,'')
    if res_hash['error']
      puts error_color("Error: #{res_hash['error_message']}")
    else
      puts success_color("No errors!")
    end
  else
    '[ ' + error_color('FAIL') + ' ]'
  end
end

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
