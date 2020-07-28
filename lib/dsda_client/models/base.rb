module DsdaClient
  module Models
    class Base
      class << self
        def require_keys(*args)
          @required_keys = args
        end

        def required_keys
          @required_keys ||= []
        end

        def allow_keys(*args)
          @allowed_keys = (args + @required_keys).flatten
        end

        def allowed_keys
          @allowed_keys ||= required_keys
        end

        def invalid?(raw_hash)
          !valid?(raw_hash)
        end

        def valid?(raw_hash)
          raw_hash.includes_only?(allowed_keys) &&
          raw_hash.includes_all?(required_keys)
        end
      end
    end
  end
end
