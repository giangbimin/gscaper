class CreateUserOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :user_orders do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.text :content, default: ""

      t.timestamps
    end
  end
end
