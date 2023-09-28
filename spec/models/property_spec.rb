require 'rails_helper'
RSpec.describe Property, type: :model do
  describe 'Associations' do
    it { should belong_to(:user)}
    it { should have_one(:address)}
  end

  describe 'allow nested attributes' do
    it "accepts nested attributes for address" do
      should accept_nested_attributes_for(:address)
    end
  end
end
