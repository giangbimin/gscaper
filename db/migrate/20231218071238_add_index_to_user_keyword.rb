class AddIndexToUserKeyword < ActiveRecord::Migration[7.1]
  def change
    add_index :user_keywords, [:user_id, :keyword_id], unique: true
  end
end
