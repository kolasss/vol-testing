class PostPolicy < ApplicationPolicy

  def create?
    @user.present?
  end

  def update?
    @record.author == @user ||
    @user.admin?
  end

  def destroy?
    update?
  end
end
