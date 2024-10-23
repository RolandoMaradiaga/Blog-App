class Post < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :comments, dependent: :destroy

  # Validations
  validates :title, presence: true
  validates :body, presence: true

  # Full-Text Search Configuration
  include PgSearch::Model
  pg_search_scope :search_by_title_and_body, 
                  against: { title: 'A', body: 'B' }, 
                  using: {
                    tsearch: { prefix: true }
                  }
end
