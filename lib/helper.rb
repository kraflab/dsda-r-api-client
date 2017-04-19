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
def do_request(uri, query, request_type)
  print "Issuing #{request_type.upcase} request... "
  
  # set api query header
  req = case request_type
  when :post
    Net::HTTP::Post.new(uri)
  else
    Net::HTTP::Get.new(uri)
  end
  req['API'] = query.to_json
  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) {|http|
    http.request(req)
  }
  
  if res.is_a? Net::HTTPSuccess
    puts '[ ' + success_color('SUCCESS') + ' ]'
    res_hash = JSON.parse(res.body)
    puts JSON.pretty_generate(res_hash.except('error', 'error_message')).gsub(/"/,'')
    if res_hash['error']
      puts error_color("Error: #{res_hash['error_message']}")
      puts "(#{query.except(:password)})"
    else
      puts success_color("Success!")
    end
  else
    puts '[ ' + error_color('FAIL') + ' ]'
    puts error_color("Error: #{res.code}")
    puts "(#{query.except(:password)})"
  end
end

# parse api commands
def parse_commands(args, request_hash, root_uri, target)
  case id = args.shift
  when '='
    request_type = :post
    fields = split_array(args, ':').flatten
    request_hash[:demo] = {}
    while !fields.empty?
      case this_field = fields.shift
      when 'players'
        request_hash[:demo][this_field] = fields.shift.split(/,\s*/)
      when 'tags'
        tag_strings = fields.shift.split(/;\s*/).map { |str| str.split(/,\s*/) }
        tag_array = tag_strings.map { |ary| {'text' => ary[0], 'style' => ary[1]} }
        request_hash[:demo][this_field] = tag_array
      when 'file'
        file_name = fields.shift
        next if file_name.empty?
        if File.file? file_name
          request_hash[:demo][:file] = {
            name: file_name.split('/').last,
            data: Base64.encode64(File.open(file_name, 'rb').read)
          }
        else
          puts error_color("File not found: #{file_name}")
          error = true
          break
        end
      else
        request_hash[:demo][this_field] = fields.shift
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
      request_hash[:mode] = 'random'
    else
      request_hash[:mode] = 'fixed'
      request_hash[:id] = id
    end
    request_hash[:commands] = {}
    if commands.empty?
      request_hash[:commands][:properties] = 'all'
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
              request_hash[:commands][:record] = {level: level, category: category}
            else
              puts error_color("Missing record details: level and category")
              error = true
            end
          end
        when 'count'
          model = command.shift
          if model
            request_hash[:commands][:count] ||= []
            request_hash[:commands][:count].push model
          else
            puts error_color("Missing count detail: model")
            error = true
          end
        when 'properties'
          request_hash[:commands][:properties] = 'all'
        when 'stats'
          request_hash[:commands][:stats] = 'all'
        else
          puts error_color("Unknown request command #{comm}")
          error = true
        end
      end
    end
  end
  unless error
    uri = URI(root_uri + "/#{target}/")
    do_request(uri, request_hash, request_type)
  end
end
