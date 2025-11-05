class CreateStats < ActiveRecord::Migration[8.0]
  def change
    create_table :stats do |t|
      t.references :account, foreign_key: true
      t.integer :followers
      t.integer :likes
      t.integer :posts
      t.date :date
      t.timestamps
    end
  end
end
