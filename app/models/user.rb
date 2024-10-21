class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  ROLES = %w[guest author].freeze

  def author?
    role == 'author'
  end

  def guest?
    role == 'guest'
  end
end
