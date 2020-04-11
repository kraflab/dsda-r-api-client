require 'dsda_client/terminal'
require 'dsda_client/token_manager'

module DsdaClient
  class Api
    def self.setup(options)
      @variable_prefix = "DSDA_API_#{options.production? ? '' : 'DEV_'}"
    end

    def self.method_missing(m, *args, &block)
      name = @variable_prefix + m.to_s.upcase
      ENV[name] || fail("Environment variable #{name} not found")
    end

    def self.token
      TokenManager.get_token
    end
  end
end
