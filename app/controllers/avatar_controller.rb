class AvatarController < ActionController::Base
  include UserAuthentication::Controller
  protect_from_forgery with: :exception

  # костыль чтобы не передавать токен через браузер
  before_action :require_login, if: 'params[:id].nil?'

  def index
    set_user
  end

  def create
    set_user
    if @user.update user_params
      # костыль чтобы не передавать токен через браузер
      redirect_to avatar_path(id: params[:id]), notice: 'Аватар обновлен.'
    else
      render :index
    end
  end

  private

    def set_user
      # костыль чтобы не передавать токен через браузер
      if params[:id].present?
        @user = Users::User.find params[:id]
      else
        @user = current_user
      end
    end

    def user_not_authenticated
      render(plain: 'unauthorized', status: :unauthorized)
    end

    def user_params
      params.require(:users_user).permit(
        :avatar,
        :avatar_cache,
        :remove_avatar
      )
    end
end

