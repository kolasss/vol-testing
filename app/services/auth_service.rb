class AuthService
  def initialize(params)
    if params
      @email = params[:email]
      @password = params[:password]
    end
  end

  def login(request)
    user = Users::User.find_by email: @email
    if user && user.authenticate(@password)
      # generate token
      info = {user_agent: request.user_agent}
      auth = user.authentications.create info: info
      # encode token
      UserAuthentication::AuthToken.encode({ auth_id: auth.id })
    else
      return nil
    end
  end
end
