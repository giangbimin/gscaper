class Keyword < ApplicationRecord
  validates :content, presence: true
  enum status: { pending: 0, processed: 1, failed: 2 }
end
