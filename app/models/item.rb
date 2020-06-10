class Item < ApplicationRecord
  belongs_to :merchant
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :reviews, dependent: :destroy

  validates_presence_of :name,
                        :description,
                        :image,
                        :price,
                        :inventory

  def self.active_items
    where(active: true)
  end

  def self.by_popularity(limit = nil, order = "DESC")
    left_joins(:order_items)
    .select('items.id, items.name, COALESCE(sum(order_items.quantity), 0) AS total_sold')
    .group(:id)
    .order("total_sold #{order}")
    .limit(limit)
  end

  def sorted_reviews(limit = nil, order = :asc)
    reviews.order(rating: order).limit(limit)
  end

  def average_rating
    reviews.average(:rating)
  end

  def all_applicable_discounts(quantity)
    merchant.discounts_meeting_quantity_required(quantity)
  end 

  def best_applicable_discount(quantity)
    all_applicable_discounts(quantity).highest_discount
  end 
  
  def discounted_price(percent_off)
    price - (price * (percent_off.to_f * 0.01))
  end 

  def final_price(quantity)
    discount = best_applicable_discount(quantity)

    return discounted_price(discount.percent_off) if discount
    return price
  end 
end
