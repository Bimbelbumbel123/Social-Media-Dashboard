class CreateStats < ActiveRecord::Migration[8.0]
  def change
    create_table :stats do |t|
      t.timestamps
    end
  end
end
