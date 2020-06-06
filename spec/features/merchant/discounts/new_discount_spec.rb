require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'New Merchant Discount' do
  describe 'As a Merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'US 1 - I click a link to edit a discount' do
      visit merchant_dashboard_path

      click_link 'New Discount'

      expect(current_path).to eq(new_merchant_discount_path)
    end

    it 'US 1 - I can create a discount for a merchant' do
      name = '20 % off 5 items'
      percent_off = 20
      quantity_required = 5

      visit new_merchant_discount_path

      fill_in 'Name', with: name
      fill_in 'Percentage Off', with: percent_off
      fill_in 'Quantity Required', with: quantity_required
      click_button 'Create Discount'

      @discount = Discount.last

      expect(current_path).to eq(merchant_discount_path(@discount))
      expect(page).to have_content(name)
      expect(page).to have_content(number_to_percentage(@discount.percent_off, precision: 0))
      expect(page).to have_content(quantity_required)
      expect(page).to have_content(@discount.enabled)
    end
    # it 'I can not create an  item for a merchant with an incomplete form' do
    #   name = 'Ogre'

    #   visit "/merchant/items/new"

    #   fill_in 'Name', with: name
    #   click_button 'Create Item'

    #   expect(page).to have_content("description: [\"can't be blank\"]")
    #   expect(page).to have_content("price: [\"can't be blank\"]")
    #   expect(page).to have_content("image: [\"can't be blank\"]")
    #   expect(page).to have_content("inventory: [\"can't be blank\"]")
    #   expect(page).to have_button('Create Item')
    # end
  end
end