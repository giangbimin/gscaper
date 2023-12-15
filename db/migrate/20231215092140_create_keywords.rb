class CreateKeywords < ActiveRecord::Migration[7.1]
  def change
    create_table :keywords do |t|
      t.string :content, null: false
      t.integer :status, null: false, default: 0
      t.integer :total_link, null: false, default: 0
      t.bigint :total_result, null: false, default: 0
      t.integer :total_ad, null: false, default: 0
      t.text :html_code, default: ""

      t.timestamps
    end
  end
end
