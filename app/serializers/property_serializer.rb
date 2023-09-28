class PropertySerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :price_per_month, :no_of_rooms, :property_type, :user_id, :net_size, :net_size_in_sqr_feet, :is_favourite, :image_url
  has_one :address

  def net_size_in_sqr_feet
    object.net_size * 35.5832 if object.net_size.present?
  end

  def is_favourite
    FavouriteProperty.where(property_id: object.id, user_id: current_user.id).present?
  end

  def image_url
    Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true) if object.image.present?
  end
end
