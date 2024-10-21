class Comment < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :post

  # Validations
  validates :body, presence: true
end
