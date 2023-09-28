class FavouriteProperty < ApplicationRecord
  self.table_name = :favourite_properties
  belongs_to :user
  belongs_to :property
end
