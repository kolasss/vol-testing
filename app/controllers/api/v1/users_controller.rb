class Api::V1::UsersController < Api::V1::ApplicationController
  before_action :require_login, only: [:update, :destroy, :change_role]

  # GET /users
  # GET /users.json
  def index
    # authorize Users::User
    @users = Users::User.by_created
    render json: @users, each_serializer: Users::UserSerializer
  end

  # GET /users/1
  # GET /users/1.json
  def show
    set_user
    render json: @user
  end

  # POST /users
  # POST /users.json
  def create
    # authorize Users::User
    @user = Users::User.new(user_params)
    if NewUserService.new(@user).create
      render json: @user, status: :created
    else
      render_user_errors
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    set_user
    @user = Users::User.find(params[:id])

    if @user.update(user_params)
      render json: @user
    else
      render_user_errors
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    set_user
    if @user.destroy
      head :no_content
    else
      render_user_errors
    end
  end

  # PUT /users/1/change_role
  def change_role
    set_user

    if @user.update(role: params[:user][:role])
      render json: @user
    else
      render_user_errors
    end
  end

  private

    def set_user
      @user = Users::User.find(params[:id])
      # authorize @user
    end

    def user_params
      params.require(:user).permit(
        :nickname,
        :email,
        :password
      )
    end

    def render_user_errors
      render json: {errors: @user.errors}, status: :unprocessable_entity
    end
end
