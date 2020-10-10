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

        def require_otp
          @require_otp = true
        end

        def otp_required?
          @require_otp == true
        end

        def invalid?(raw_hash)
          !valid?(raw_hash)
        end

        def valid?(raw_hash)
          raw_hash.includes_only?(allowed_keys) &&
          raw_hash.includes_all?(required_keys) &&
          (!otp_required? || !Options.otp.nil?)
        end
      end
    end
  end
end
