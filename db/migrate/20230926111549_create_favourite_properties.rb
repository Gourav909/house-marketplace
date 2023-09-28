class CreateFavouriteProperties < ActiveRecord::Migration[7.0]
  def change
    create_table :favourite_properties do |t|
      t.integer :user_id
      t.integer :property_id
      t.boolean :is_favourite
      t.timestamps
    end
  end
end
