class CreatePlatforms < ActiveRecord::Migration[8.0]
  def change
    create_table :platforms do |t|
      t.string :platform_name
      t.string :icon_url
      t.timestamps
    end
  end
end
