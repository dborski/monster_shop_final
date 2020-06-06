class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :name, :percent_off, :quantity_required
end