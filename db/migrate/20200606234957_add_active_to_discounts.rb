class AddActiveToDiscounts < ActiveRecord::Migration[5.1]
  def change
    add_column :discounts, :active, :boolean, default: true
    change_column :discounts, :enabled, :boolean, default: false
  end
end
