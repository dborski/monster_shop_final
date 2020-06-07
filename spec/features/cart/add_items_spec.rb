require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe "Add Items to Cart" do
  describe "As a Visitor" do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
    end

    it "I can add an item from the items show page" do
      visit item_path(@ogre)

      click_button 'Add to Cart'

      expect(current_path).to eq(items_path)
      expect(page).to have_content("#{@ogre.name} has been added to your cart!")
      expect(page).to have_content("Cart: 1")
    end

    it "I can add multiple items from the items show page" do
      visit item_path(@ogre)

      click_button 'Add to Cart'

      visit item_path(@giant)

      click_button 'Add to Cart'

      expect(page).to have_content("#{@giant.name} has been added to your cart!")
      expect(page).to have_content("Cart: 2")
    end
  end
  describe "As a User" do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 100 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 10, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 100 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 100 )

      @user = create(:user)

      @discount1 = create(:discount, percent_off: 10, quantity_required: 5, merchant: @megan, enabled: true)
      @discount2 = create(:discount, percent_off: 20, quantity_required: 6, merchant: @megan)
      @discount3 = create(:discount, percent_off: 20, quantity_required: 6, merchant: @megan, enabled: true)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it "when I add an item to my cart that has a bulk discount, the active discount is applied" do
      visit item_path(@ogre)

      click_button 'Add to Cart'

      visit cart_path

      within "#item-#{@ogre.id}" do
        3.times { click_button('More of This!') }
      end

      within "#item-#{@ogre.id}" do
        expect(page).to have_content("Price: $50.00")
        expect(page).to have_content("Subtotal: $200.00")
      end
      
      within "#item-#{@ogre.id}" do
        click_button('More of This!')
      end
      
      within "#item-#{@ogre.id}" do
        expect(page).to have_content("Price: $45.00")
        expect(page).to have_content("Subtotal: $225.00")
      end
    end

    it "When I add items that have two or more discounts on them, the highest discount is applied" do
      visit item_path(@ogre)

      click_button 'Add to Cart'

      visit cart_path

      within "#item-#{@ogre.id}" do
        5.times { click_button('More of This!') }
      end

      within "#item-#{@ogre.id}" do
        expect(page).to have_content("Price: $40.00")
        expect(page).to have_content("Subtotal: $240.00")
      end
    end
    it "When adding discounted items, the grandtotal is updated" do
      visit item_path(@ogre)

      click_button 'Add to Cart'

      visit item_path(@giant)

      click_button 'Add to Cart'

      visit cart_path

      within "#item-#{@ogre.id}" do
        3.times { click_button('More of This!') }
      end

      expect(page).to have_content("Total: $210.00")
      
      within "#item-#{@ogre.id}" do
        click_button('More of This!')
      end
      
      expect(page).to have_content("Total: $235.00")
      
      within "#item-#{@ogre.id}" do
        click_button('More of This!')
      end

      expect(page).to have_content("Total: $250.00")
    end
  end
end
