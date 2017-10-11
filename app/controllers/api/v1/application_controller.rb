class Api::V1::ApplicationController < ActionController::Base
  include UserAuthentication::Controller
  include Pundit

  # fix вызов current_user в AMS
  serialization_scope nil

  # если нет прав на действие
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

    # нет прав
    def user_not_authorized
      head :forbidden
    end

    # не залогинен
    def user_not_authenticated
      head :unauthorized
    end
end

