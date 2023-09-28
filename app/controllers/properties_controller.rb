class PropertiesController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  # before_action :search_by_params, only: [:index]
  # before_action :filters, only: [:index]


  def index
    properties = params[:search] ? search_by_params : filters
    render json: properties.page(params[:page]).per(10), each_serializer: PropertySerializer
  end

  def show
    render json: @property, serializer: PropertySerializer, status: :ok
  end

  def create
    property = current_user.properties.new(property_params)
    if property.save
      render json: property, serializer: PropertySerializer, status: 201
    else
      render json: { errors: property.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @property.update(property_params)
      render json: @property, serializer: PropertySerializer , status: :ok
    else
      render json: { errors: @property.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @property.destroy
      render json: { message: "Property removed successfully." }
    else
      render json: { errors: @property.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def filters
    filters = params["filter_by"]
    return Property.all unless filters
    conditions = []

    filters.each do |column, value|
      if ["city", "district"].include?(column)
        conditions << ["addresses.#{column} = ?", value]
      else
        conditions << ["#{column} = ?", value]
      end
    end
    Property.joins(:address).where(conditions.map(&:first).join(" AND "), *conditions.map(&:last)).distinct
  end

  def search_by_params
    return Property.all unless params[:search].present?

    Property.joins(:address).where('addresses.city LIKE :search or addresses.district LIKE :search or price_per_month LIKE :search or property_type LIKE :search or no_of_rooms LIKE :search', search: "%#{params[:search]}%")
  end

  def property_params
    params.permit(:title, :price_per_month, :no_of_rooms, :property_type, :net_size, :description, :image, address_attributes: address_params)
  end

  def address_params
    [:id, :city, :district, :_destroy]
  end
end
