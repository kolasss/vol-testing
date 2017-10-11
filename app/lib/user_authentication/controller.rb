# аутентификация сделана частично
# по туториалу http://adamalbrecht.com/2015/07/20/authentication-using-json-web-tokens-using-rails-and-react/
# метод user_not_authenticated определен в application_controller


module UserAuthentication
  module Controller
    extend ActiveSupport::Concern

    private

      def require_login
        if !logged_in?
          user_not_authenticated
        end
      end

      def logged_in?
        !!current_user
      end

      def current_user
        @current_user ||= login_from_token
      end

      def login_from_token
        if auth_id_included_in_auth_token?
          Users::User.find_by_auth_id(decoded_auth_token[:auth_id])
        end
      rescue JWT::VerificationError, JWT::DecodeError, JWT::InvalidIatError
        user_not_authenticated
      end

      # Authentication Related Helper Methods
      # ------------------------------------------------------------
      def auth_id_included_in_auth_token?
        http_auth_token && decoded_auth_token && decoded_auth_token[:auth_id]
      end

      # Raw Authorization Header token (json web token format)
      # JWT's are stored in the Authorization header using this format:
      # Bearer somerandomstring.encoded-payload.anotherrandomstring
      def http_auth_token
        @http_auth_token ||= if request.headers['Authorization'].present?
                               request.headers['Authorization'].split(' ').last
                             end
      end

      # Decode the authorization header token and return the payload
      def decoded_auth_token
        @decoded_auth_token ||= UserAuthentication::AuthToken.decode(http_auth_token)
      end
  end
end
