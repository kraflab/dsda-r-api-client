require 'dsda_client/terminal'

module DsdaClient
  class Api
    def self.method_missing(m, *args, &block)
      name = "DSDA_API_#{m.upcase}"
      ENV[name] || fail("Environment variable #{name} not found")
    end
  end
end
