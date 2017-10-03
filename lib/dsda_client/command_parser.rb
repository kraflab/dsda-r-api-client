require 'base64'
require 'cgi'
require 'dsda_client/request_service'
require 'dsda_client/terminal'

module DsdaClient
  class CommandParser
    def initialize(root_uri, options)
      @root_uri = root_uri
      @options = options
    end

    def parse(args, request_hash, model, original)
      body_hash = {}
      case id = args.shift
      when '='
        action = :post
        fields = split_array(args, ':').flatten
        body_hash[model] = {}
        while !fields.empty?
          case this_field = fields.shift
          when 'players'
            body_hash[model][this_field] = fields.shift.split(/,\s*/)
          when 'tags'
            tag_strings = fields.shift.split(/;\s*/).map { |str| str.split(/,\s*/) }
            tag_array = tag_strings.map { |ary| {'text' => ary[0], 'style' => ary[1]} }
            body_hash[model][this_field] = tag_array
          when 'file'
            file_name = fields.shift
            next if file_name.empty?
            if File.file? file_name
              body_hash[model][:file] = {
                name: file_name.split('/').last,
                data: Base64.encode64(File.open(file_name, 'rb').read)
              }
            else
              DsdaClient::Terminal.error("File not found: #{file_name}")
              error = true
              break
            end
          else
            body_hash[model][this_field] = fields.shift
          end
        end
      when nil
        DsdaClient::Terminal.error("Missing id")
        error = true
      else
        action = :get
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
              if model != 'wad'
                DsdaClient::Terminal.error("Invalid command record for #{model}")
                error = true
              else
                level = command.shift
                category = command.shift
                if level and category
                  body_hash[:commands][:record] = {level: level, category: category}
                else
                  DsdaClient::Terminal.error("Missing record details: level and category")
                  error = true
                end
              end
            when 'count'
              sub_model = command.shift
              if sub_model
                body_hash[:commands][:count] ||= []
                body_hash[:commands][:count].push sub_model
              else
                DsdaClient::Terminal.error("Missing count detail: model")
                error = true
              end
            when 'properties'
              body_hash[:commands][:properties] = 'all'
            when 'stats'
              body_hash[:commands][:stats] = 'all'
            else
              DsdaClient::Terminal.error("Unknown request command #{comm}")
              error = true
            end
          end
        end
      end
      unless error
        dump_and_exit(body_hash) if @options.dump_requests?
        uri = URI(@root_uri + "/#{model}s/")
        RequestService.new(@options).request(uri, request_hash, body_hash, action, original)
      end
    end

    private

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

    def prune_raw_data!(obj)
      if obj.is_a?(Hash)
        obj[:data] = '[pruned]' if obj[:data]
      end
      if obj.is_a?(Enumerable)
        obj.each do |element|
          prune_raw_data!(element)
        end
      end
    end

    def dump_and_exit(body)
      prune_raw_data!(body)
      puts JSON.pretty_generate(body)
      exit
    end
  end
end
