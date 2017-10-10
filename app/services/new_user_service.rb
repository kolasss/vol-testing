class NewUserService
  def initialize(user)
    @user = user
  end

  def create
    set_defaults
    @user.save
  end

  private

    def set_defaults
      @user.role ||= Users::User::USER_ROLES[0]
    end
end
