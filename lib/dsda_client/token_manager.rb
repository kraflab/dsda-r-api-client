require 'dsda_client/api'
require 'dsda_client/request_service'

module DsdaClient
  module TokenManager
    extend self

    TOKEN_REFRESH_PADDING = 3600

    def get_token
      read_token || refresh_token
    end

    private

    def read_token
      return unless File.exists?('.token')

      token_data = File.read('.token').split
      token = token_data[0]
      expiration_time = token_data[1]
      return if expiration_time.to_i < Time.now.to_i + TOKEN_REFRESH_PADDING

      token
    end

    def refresh_token
      response = request_token

      if response['token'].nil?
        terminal.print('Unable to authenticate! Aborting...')
        exit(1)
      end

      File.write('.token', "#{response['token']} #{response['exp']}")

      response['token']
    end

    def request_token
      uri = URI(Api.location + '/tokens')
      payload = {
        username: Api.username,
        password: Api.password
      }
      RequestService.new(Options.options).request(uri, {}, payload)
    end
  end
end
