class CommentPolicy < ApplicationPolicy
  def update?
    user.author? && record.user == user
  end

  def destroy?
    user.author? && record.user == user
  end

  def create?
    user.present? # Both guests and authors can create comments
  end
end
