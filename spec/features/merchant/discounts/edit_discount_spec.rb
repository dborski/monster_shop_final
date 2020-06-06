require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Edit Merchant Discount' do
  describe 'As a Merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount1 = create(:discount, merchant_id: @merchant_1.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'US 2 - I can click a link to edit a discount from discount show page' do
      visit merchant_discount_path(@discount1)

      click_link 'Edit Discount'

      expect(current_path).to eq(edit_merchant_discount_path)
    end

    xit 'US 1 - I can edit a discount for a merchant' do
      name = '20 % off 5 items'
      percent_off = 20
      quantity_required = 5

      visit edit_merchant_discount_path

      fill_in 'Name', with: name
      fill_in 'Percentage Off', with: percent_off
      fill_in 'Quantity Required', with: quantity_required
      click_button 'Edit Discount'

      expect(current_path).to eq(merchant_discount_path(@discount1))
      expect(page).to have_content(name)
      expect(page).to have_content(number_to_percentage(@discount.percent_off, precision: 0))
      expect(page).to have_content(quantity_required)
      expect(page).to have_content(@discount.enabled)
    end
  end
end

# User Story 2 - Discount Update

# As a merchant,
# When I visit a discount's show page
# I see a link to edit the discount
# When I click on this link, I am taken to an edit discount review path
# On this new page, I see a form that includes that review's pre populated data:
# - name
# - % off
# - quantity required
# I can update any of these fields and submit the form.
# When the form is submitted, I should return to that discount's show page
# And I can see my updated discount
