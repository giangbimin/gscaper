class AddUserOrderToKeyword < ActiveRecord::Migration[7.1]
  def change
    add_reference :keywords, :user_order, null: false, foreign_key: true
  end
end
