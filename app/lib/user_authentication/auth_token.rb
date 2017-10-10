module UserAuthentication
  class AuthToken
    HMAC_SECRET = Rails.application.secrets.secret_key_base

    # Encode a hash in a json web token
    def self.encode payload
      # The iat (issued at) claim identifies the time at which the JWT was issued. This claim can be used to determine the age of the JWT. Its value MUST be a number containing a NumericDate value. Use of this claim is OPTIONAL.
      iat = Time.current.to_i
      payload[:iat] = iat
      JWT.encode payload, HMAC_SECRET, 'HS256'
    end

    # Decode a token and return the payload inside
    # If will throw an error if expired or invalid. See the docs for the JWT gem.
    def self.decode token
      decoded = JWT.decode token, HMAC_SECRET, true, { :verify_iat => true, :algorithm => 'HS256' }
      HashWithIndifferentAccess.new(decoded[0])
    end
  end
end
