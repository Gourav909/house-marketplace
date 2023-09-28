# spec/controllers/properties_controller_spec.rb

require 'rails_helper'

RSpec.describe PropertiesController, type: :controller do
  include ActionController::RespondWith
  let(:admin_user) { create(:user, type: 'Admin') }
  let(:user) { create(:user, type: 'User') }
  let!(:property) { create(:property, user: admin_user) }

  before(:each) do
    auth_headers = admin_user.create_new_auth_token
    request.headers.merge(auth_headers)
  end

  describe "GET #index" do
    context "as an admin user" do
      let(:user) { create(:user, type: 'Admin') }
      let!(:property) { create(:property, user: admin_user) }
      it "returns a successful response" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET #show" do
    context "as an admin user" do
      it "returns a successful response" do
        get :show, params: { id: property.id }
        expect(response).to have_http_status(:success)
      end
    end

     context "when property does not exist" do
      it "returns a not found response" do
        get :show, params: { id: 9999 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST #create" do
    context "as an admin user" do

      it "creates a new property" do
        property_params = attributes_for(:property)
        post :create, params: property_params, format: :json

        expect(response).to have_http_status(:created)
      end
    end

    context "when property params are invalid" do
      it "returns an unprocessable entity response" do
        post :create, params: {title: nil }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT #update" do
    context "when the update is successful" do
      it "returns a successful response" do
        put :update, params: {id: property.id, title:  "Updated Title"}, format: :json
        expect(response).to have_http_status(:success)
        expect(property.reload.title).to eq("Updated Title")
      end
    end

    context "when property does not exist" do
      it "returns an unprocessable entity response" do
        put :update, params: {id: 9999}, format: :json
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when the property exists and is owned by the user" do
      it "returns a successful response" do
        delete :destroy, params: { id: property.id }, format: :json
        expect(response).to have_http_status(:success)
      end

      it "deletes the property" do
        expect do
          delete :destroy, params: { id: property.id }, format: :json
        end.to change(Property, :count).by(-1)
      end
    end
  end
end
