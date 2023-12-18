class AddIndexToKeyword < ActiveRecord::Migration[7.1]
  def change
    add_index :keywords, :content
  end
end
