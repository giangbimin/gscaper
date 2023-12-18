class UserKeyword < ApplicationRecord
  belongs_to :user
  belongs_to :keyword
  # rubocop:disable Rails/UniqueValidationWithoutIndex
  validates :keyword_id, uniqueness: { scope: :keyword_id }
  # rubocop:enable Rails/UniqueValidationWithoutIndex
end
