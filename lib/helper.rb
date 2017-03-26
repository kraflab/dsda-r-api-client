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

# collect an input command
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
    puts '[ ' + error_color('FAIL') + ' ]'
  end
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
