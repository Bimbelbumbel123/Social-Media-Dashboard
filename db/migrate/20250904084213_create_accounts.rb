class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.integer :account_id
      t.string :platform
      t.string :username
      t.integer :likes
      t.integer :clicks
      t.integer :comments
      t.integer :dislikes
      t.integer :posts_count

      t.timestamps
    end
  end
end
