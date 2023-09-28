# spec/controllers/properties_controller_spec.rb

require 'rails_helper'

RSpec.describe FavouritePropertiesController, type: :controller do
  include ActionController::RespondWith
  let(:admin_user) { create(:user, type: 'Admin') }
  let(:user) { create(:user, type: 'User') }
  let(:property) { create(:property, user: admin_user, property_type: "residential") }

  before(:each) do
    auth_headers = admin_user.create_new_auth_token
    request.headers.merge(auth_headers)
  end

  describe "GET #index" do
    context "as a normal user" do
      it "creates a new favourite property" do
        favourite_property_params = attributes_for(:favourite_property)
        get :index
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST #create" do
    context "as a normal user" do
      it "creates a new favourite property" do
        favourite_property_params = attributes_for(:favourite_property)
        post :create, params: { favourite_property: favourite_property_params, property_id: property.id }, format: :json
        expect(response).to have_http_status(:created)
      end
    end

    context "when favourite property params are invalid" do
      it "returns an unprocessable entity response" do
        favourite_property_params = attributes_for(:favourite_property)
        post :create, params: { favourite_property: favourite_property_params, property_id: 0}, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:favourite_property) { create(:favourite_property, user: user, property_id: property.id) }
    context "when the favourite property exists and is owned by the user" do
      it "deletes the property" do
        expect do
          delete :destroy, params: { id: property.id }, format: :json
        end.to change(FavouriteProperty, :count).by(-1)
      end
    end
  end
end
