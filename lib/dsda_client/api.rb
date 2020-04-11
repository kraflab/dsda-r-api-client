require 'dsda_client/terminal'
require 'dsda_client/token_manager'

module DsdaClient
  module Api
    extend self

    def setup(options)
      @key_prefix = "DSDA_API_#{options.production? ? '' : 'DEV_'}"
    end

    def username
      retrieve(:username)
    end

    def password
      retrieve(:password)
    end

    def location
      retrieve(:location)
    end

    def token
      @token ||= TokenManager.get_token
    end

    private

    def retrieve(key)
      name = @key_prefix + key.to_s.upcase
      ENV[name] || fail("Environment variable #{name} not found")
    end
  end
end
