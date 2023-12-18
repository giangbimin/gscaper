class UserKeyword < ApplicationRecord
  belongs_to :user
  belongs_to :keyword
  validates :keyword_id, uniqueness: { scope: :keyword_id }
end
