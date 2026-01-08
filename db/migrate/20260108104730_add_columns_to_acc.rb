class AddColumnsToAcc < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :platform_user_id, :string
    add_column :accounts, :access_token, :string
    add_column :accounts, :refresh_token, :string
    add_column :accounts, :token_expires_at, :datetime
  end
end
