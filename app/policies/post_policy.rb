class PostPolicy < ApplicationPolicy
  def update?
    edit?
  end

  def edit?
    user.author? && record.user == user
  end

  def destroy?
    user.author? && record.user == user
  end

  def create?
    user.author?
  end

  def index?
    true # Everyone can see the list of posts
  end

  def show?
    true # Everyone can view individual posts
  end
  
end
