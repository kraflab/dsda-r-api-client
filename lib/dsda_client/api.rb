require 'dsda_client/terminal'

module DsdaClient
  class Api
    def self.setup(options)
      @variable_prefix = "DSDA_API_#{options.production? ? '' : 'DEV_'}"
    end

    def self.method_missing(m, *args, &block)
      name = @variable_prefix + m.to_s.upcase
      ENV[name] || fail("Environment variable #{name} not found")
    end
  end
end
