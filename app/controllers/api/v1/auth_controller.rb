class Api::V1::AuthController < Api::V1::ApplicationController
  # before_action :skip_authorization
  before_action :require_login, only: [:destroy_tokens]

  # POST /auth
  def login
    if @auth_token = AuthService.new(params[:user]).login(request)
      render json: @auth_token
    else
      render json: {errors: ['Invalid email/password']}, status: :unauthorized
    end
  end

  # DELETE /auth
  def destroy_tokens
    if params[:token] == 'current'
      @auth = current_auth_by_token
      @auth.destroy
      head :no_content
    elsif params[:token] == 'other'
      @auths = current_user.authentications.where.not(id: decoded_auth_token[:auth_id])
      @auths.destroy_all
      head :no_content
    else
      render json: {errors: ['Invalid parameter']}, status: :unprocessable_entity
    end
  end

  private

    def current_auth_by_token
      current_user.authentications.find decoded_auth_token[:auth_id]
    end
end
