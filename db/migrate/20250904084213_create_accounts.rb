class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :platform
      t.string :username
      t.integer :likes
      t.integer :clicks

      t.timestamps
    end
  end
end
