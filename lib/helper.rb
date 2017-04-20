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
      result.push args unless args.empty?
      return result
    else
      args[cut][-1] = ''
      result.push args.slice!(0..cut)
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
def do_request(uri, query, body, request_type, original)
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

# parse api commands
def parse_commands(args, request_hash, root_uri, target, original)
  body_hash = {}
  case id = args.shift
  when '='
    request_type = :post
    fields = split_array(args, ':').flatten
    body_hash[:demo] = {}
    while !fields.empty?
      case this_field = fields.shift
      when 'players'
        body_hash[:demo][this_field] = fields.shift.split(/,\s*/)
      when 'tags'
        tag_strings = fields.shift.split(/;\s*/).map { |str| str.split(/,\s*/) }
        tag_array = tag_strings.map { |ary| {'text' => ary[0], 'style' => ary[1]} }
        body_hash[:demo][this_field] = tag_array
      when 'file'
        file_name = fields.shift
        next if file_name.empty?
        if File.file? file_name
          body_hash[:demo][:file] = {
            name: file_name.split('/').last,
            data: Base64.encode64(File.open(file_name, 'rb').read)
          }
        else
          puts error_color("File not found: #{file_name}")
          error = true
          break
        end
      else
        body_hash[:demo][this_field] = fields.shift
      end
    end
  when nil
    puts error_color("Missing id")
    error = true
  else
    request_type = :get
    error = false
    commands = split_array(args, ';')
    if id == '?'
      body_hash[:mode] = 'random'
    else
      body_hash[:mode] = 'fixed'
      body_hash[:id] = id
    end
    body_hash[:commands] = {}
    if commands.empty?
      body_hash[:commands][:properties] = 'all'
    else
      commands.each do |command|
        case comm = command.shift
        when 'record'
          if target != 'wads'
            puts error_color("Invalid command record for #{target}")
            error = true
          else
            level = command.shift
            category = command.shift
            if level and category
              body_hash[:commands][:record] = {level: level, category: category}
            else
              puts error_color("Missing record details: level and category")
              error = true
            end
          end
        when 'count'
          model = command.shift
          if model
            body_hash[:commands][:count] ||= []
            body_hash[:commands][:count].push model
          else
            puts error_color("Missing count detail: model")
            error = true
          end
        when 'properties'
          body_hash[:commands][:properties] = 'all'
        when 'stats'
          body_hash[:commands][:stats] = 'all'
        else
          puts error_color("Unknown request command #{comm}")
          error = true
        end
      end
    end
  end
  unless error
    uri = URI(root_uri + "/#{target}/")
    do_request(uri, request_hash, body_hash, request_type, original)
  end
end
