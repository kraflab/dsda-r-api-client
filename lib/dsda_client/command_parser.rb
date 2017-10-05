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

    PLAYER_REQUIRED_KEYS = [
      'name'
    ].freeze

    PLAYER_ALLOWED_KEYS = ([
      'username'
    ] + PLAYER_REQUIRED_KEYS).freeze

    DEMO_REQUIRED_KEYS = [
      'tas',
      'guys',
      'version',
      'wad_username',
      'file',
      'engine',
      'time',
      'level',
      'levelstat',
      'category_name',
      'recorded_at',
      'players'
    ].freeze

    DEMO_ALLOWED_KEYS = ([
      'tags'
    ] + DEMO_REQUIRED_KEYS).freeze

    def valid_player?(raw_hash)
      raw_hash = raw_hash.slice(PLAYER_ALLOWED_KEYS)
      raw_hash.includes_all?(PLAYER_REQUIRED_KEYS)
    end

    def valid_demo?(raw_hash)
      raw_hash = raw_hash.slice(DEMO_ALLOWED_KEYS)
      raw_hash.includes_all?(DEMO_REQUIRED_KEYS)
    end

    def parse_file_data(instance)
      file_name = instance['file']['name']
      unless file_name.nil?
        if File.file?(file_name)
          instance['file'] = {
            name: file_name.split('/').last,
            data: Base64.encode64(File.open(file_name, 'rb').read)
          }
        else
          DsdaClient::Terminal.error("File not found: #{file_name}")
          return false
        end
      else
        DsdaClient::Terminal.error('File name not given')
        return false
      end
      true
    end

    def parse(instance, request_hash, model)
      case model
      when :demo
        error = !valid_demo?(instance)
      when :player
        error = !valid_player?(instance)
      end
      if error
        DsdaClient::Terminal.error('Error: invalid model parameters')
        return dump_input(instance)
      end

      error = !parse_file_data(instance) unless instance['file'].nil?
      return dump_input(instance) if error

      dump_and_exit(instance) if @options.dump_requests?
      uri = URI(@root_uri + "/#{model}s/")
      RequestService.new(@options).request(uri, request_hash, instance)
    end

    private

    def dump_input(instance)
      DsdaClient::Terminal.log_error(instance)
    end

    def dump_and_exit(instance)
      dump_input(instance)
      exit
    end
  end
end
