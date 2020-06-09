class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :name, :percent_off, :quantity_required

  def self.active_discounts
    Discount.where(active: true)
  end 

  def self.highest_discount
    order(percent_off: :desc).first
  end 
end 