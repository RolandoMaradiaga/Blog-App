class CommentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all # All users can view comments
    end
  end

  def create?
    true # All users (authors and guests) can create comments
  end

  def update?
    record.user == user # Users can only update their own comments
  end

  def destroy?
    record.user == user # Users can only delete their own comments
  end
end
