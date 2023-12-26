class DropUserKeyword < ActiveRecord::Migration[7.1]
  def change
    drop_table :user_keywords
  end
end
