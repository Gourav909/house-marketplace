class CreateProperties < ActiveRecord::Migration[7.0]
  def change
    create_table :properties do |t|
      t.string :title
      t.float :price_per_month
      t.integer :no_of_rooms
      t.string :property_type
      t.integer :user_id
      t.string :mrt_line
      t.integer :net_size
      t.string :description

      t.timestamps
    end
  end
end
