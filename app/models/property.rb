class Property < ApplicationRecord
  self.table_name = :properties
  belongs_to :user
  has_one :address
  has_one_attached :image

  enum property_type: { residential: 'residential', office: 'office', retail: 'retail', home: 'home' }
  accepts_nested_attributes_for :address, allow_destroy: true
  validates :title, presence: true
end
