class Keyword < ApplicationRecord
  validates :content, presence: true
  enum status: { pending: 0, processed: 1, failed: 2 }
  has_many :user_keywords, dependent: :destroy
  has_many :keywords, through: :user_keywords
end
