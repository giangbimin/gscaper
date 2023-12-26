class Keyword < ApplicationRecord
  belongs_to :user_order
  enum status: { pending: 0, processed: 1, failed: 2 }, _suffix: true
  validates :content, presence: true

  default_scope { order(id: :desc) }
  scope :search, ->(query) { where('"keywords"."content" LIKE ?', "%#{sanitize_sql_like(query)}%") }
end
