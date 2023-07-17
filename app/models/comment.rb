class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :news

  include PgSearch::Model
  pg_search_scope :search_full_text, against: {
    content: 'A',
  }
end
