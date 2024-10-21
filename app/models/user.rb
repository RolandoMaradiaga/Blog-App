class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :validatable

  ROLES = %w[guest author].freeze

  def author?
    role == 'author'
  end

  def guest?
    role == 'guest'
  end
end
