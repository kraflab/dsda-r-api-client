module DsdaClient
  module Models
    class Base
      class << self
        attr_reader :required_keys, :allowed_keys

        def require_keys(*args)
          @required_keys = args
        end

        def allow_keys(*args)
          @allowed_keys = args + @required_keys
        end

        def invalid?(raw_hash)
          !valid?(raw_hash)
        end

        def valid?(raw_hash)
          raw_hash = raw_hash.slice(*allowed_keys)
          raw_hash.includes_all?(required_keys)
        end
      end
    end
  end
end
