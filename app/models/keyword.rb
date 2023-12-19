class Keyword < ApplicationRecord
  has_many :user_keywords, dependent: :destroy
  enum status: { pending: 0, processed: 1, failed: 2 }
  validates :content, presence: true, uniqueness: true

  default_scope { order(updated_at: :desc) }
  scope :search, ->(query) { where('"keywords"."content" LIKE ?', "%#{sanitize_sql_like(query)}%") }
end
