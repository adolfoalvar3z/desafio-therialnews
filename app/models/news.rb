class News < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

	accepts_nested_attributes_for :comments, allow_destroy: true

  include PgSearch::Model
  pg_search_scope :search_full_text, against: {
    title: 'A',
    content: 'B'
  }
end
