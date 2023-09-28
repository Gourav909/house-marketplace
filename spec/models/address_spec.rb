require 'rails_helper'
RSpec.describe Address, type: :model do
  describe 'belongs to associations' do
    it { should belong_to(:property)}
  end
end
