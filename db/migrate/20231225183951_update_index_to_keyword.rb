class UpdateIndexToKeyword < ActiveRecord::Migration[7.1]
  def change
    remove_index :keywords, :content, unique: true
    add_index :keywords, :content
  end
end
