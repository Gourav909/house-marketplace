# spec/factories/properties.rb
FactoryBot.define do
  factory :property do
    title { Faker::Lorem.sentence }
    price_per_month { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    no_of_rooms { Faker::Number.between(from: 1, to: 10) }
    property_type { 'residential' }
    mrt_line { Faker::Lorem.word }
  end
end
