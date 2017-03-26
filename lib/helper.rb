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

# split an array of words into subarrays (e.g., commands split by ';')
def split_array(args, chr)
  result = []
  while true
    cut = args.index { |str| str[-1] == chr }
    if cut.nil?
      result.push args
      return result
    else
      result.push args.slice!(0..cut).collect{ |str| str.gsub(chr, '') }
    end
  end
end

# collect an input command
def prompt
  print 'dsda-r: '
  # backtrack prompt if input not from command line
  if (str = gets).nil?
    print "\r"
    exit
  else
    str.chomp
  end
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
    puts '[ ' + error_color('FAIL') + ' ]'
  end
end

# parse wad api actions
def parse_wad(args, request_hash, root_uri)
  case id = args.shift
  when nil
    puts error_color("Missing 'get wad' id")
  else
    error = false
    commands = split_array(args, ';')
    uri = URI(root_uri + "/wads/#{URI.escape(id)}")
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
end

# parse player api actions
def parse_player(args, request_hash, root_uri)
  case id = args.shift
  when nil
    puts error_color("Missing 'get player' id")
  else
    error = false
    commands = split_array(args, ';')
    uri = URI(root_uri + "/players/#{URI.escape(id)}")
    commands.each do |command|
      case command.shift
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
end
