class AddColumnsToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :comments, :integer, default: 0, null: false
    add_column :accounts, :dislikes, :integer, default: 0, null: false
  end
end
