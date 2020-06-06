FactoryBot.define do
  factory :item do
    sequence(:name) {|n| "Item #{n}" }
    sequence(:description) {|n| "Description #{n}" }
    sequence(:price, (1..100).cycle) { |n| 1 + n }
    sequence(:image) { |n| "http://img.com/#{1 + n}" }
    active { true }
    inventory { 100 }
    merchant
  end
end