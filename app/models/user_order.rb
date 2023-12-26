class UserOrder < ApplicationRecord
  belongs_to :user
  has_many :keywords, dependent: :destroy

  enum status: { pending: 0, processing: 1, processed: 2, failed: 3 }, _suffix: true
end
