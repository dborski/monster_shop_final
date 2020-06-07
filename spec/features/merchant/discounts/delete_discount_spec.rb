require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Delete Merchant Discount' do
  describe 'As a Merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount1 = create(:discount, merchant_id: @merchant_1.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'US 3 - I can delete(deactivate) a discount for a merchant' do

      visit merchant_discount_path(@discount1)

      click_link 'Delete Discount'

      expect(current_path).to eq(merchant_discounts_path)

      @discount1.reload
      expect(@discount1.active).to eq(false)
    end
  end
end