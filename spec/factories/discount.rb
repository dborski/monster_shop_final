FactoryBot.define do
  factory :discount do
    sequence(:name) {|n| "Discount #{n}" }
    percent_off { 10 }
    quantity_required { 10 }
    merchant
  end
end