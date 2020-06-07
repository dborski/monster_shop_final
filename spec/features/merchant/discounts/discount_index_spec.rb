require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Merchant Discount Index' do
  describe 'As a Merchant employee' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')

      @discount1 = create(:discount, merchant: @merchant_1)
      @discount2 = create(:discount, merchant: @merchant_1)
      @discount3 = create(:discount, merchant: @merchant_1, active: false)
      @discount4 = create(:discount, merchant: @merchant_2)
      
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'US 4 - I can link to my merchant items from the merchant dashboard' do
      visit merchant_dashboard_path

      click_link 'All Discounts'

      expect(current_path).to eq(merchant_discounts_path)
    end

    it 'US 4 - I see only my active discounts along with their name and if they are enabled' do
      visit merchant_discounts_path

      within "#discount-#{@discount1.id}" do
        expect(page).to have_link(@discount1.name)
        expect(page).to have_content(@discount1.enabled)
      end

      within "#discount-#{@discount2.id}" do
        expect(page).to have_link(@discount2.name)
        expect(page).to have_content(@discount2.enabled)
      end

      expect(page).to_not have_content(@discount3.name)
      expect(page).to_not have_content(@discount4.name)
    end
  end
end
