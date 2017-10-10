module Helpers
  def auth_header user
    auth = user.authentications.first
    header_text = "Bearer #{auth_token auth}"
    {Authorization: header_text}
  end

  def auth_header_with_auth auth
    header_text = "Bearer #{auth_token auth}"
    {Authorization: header_text}
  end

  private

    def auth_token auth
      UserAuthentication::AuthToken.encode({ auth_id: auth.id })
    end
end
