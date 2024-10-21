class PostPolicy < ApplicationPolicy
  class Scope < Scope
    # Determines which posts are accessible to the user
    def resolve
      scope.all # All users (authors and guests) can see all posts
    end
  end

  # Permissions for each action:

  # Allow all users to view posts
  def index?
    true
  end

  def show?
    true # All users can view a single post
  end

  # Only authors can create posts
  def create?
    user.author?
  end

  # Only authors can update their own posts
  def update?
    user.author? && record.user == user
  end

  # Only authors can delete their own posts
  def destroy?
    user.author? && record.user == user
  end
end
