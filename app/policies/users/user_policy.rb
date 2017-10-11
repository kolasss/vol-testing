class Users::UserPolicy < ApplicationPolicy

    def update?
      @record == @user ||
      @user.admin?
    end

    def destroy?
      @user.admin?
    end

    def change_role?
      destroy?
    end
  end
