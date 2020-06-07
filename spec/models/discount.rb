require 'rails_helper'

RSpec.describe Discount do
  describe 'Relationships' do
    it {should belong_to :merchant}
  end

  describe 'Validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :percent_off}
    it {should validate_presence_of :quantity_required}
  end

  describe 'Instance Methods' do
    before :each do
    end
  end

  describe 'Class Methods' do
    before :each do

      @discount1 = create(:discount)
      @discount2 = create(:discount)
      @discount3 = create(:discount)
      @discount4 = create(:discount)
      @discount5 = create(:discount, active: false)
      @discount6 = create(:discount, active: false)
    end
    it "active_discounts" do
      

      expect(Discount.active_discounts.include?(@discount1)).to eq(true)
      expect(Discount.active_discounts.include?(@discount2)).to eq(true)
      expect(Discount.active_discounts.include?(@discount3)).to eq(true)
      expect(Discount.active_discounts.include?(@discount4)).to eq(true)
      expect(Discount.active_discounts.include?(@discount5)).to eq(false)
      expect(Discount.active_discounts.include?(@discount6)).to eq(false)
    end
  end
end