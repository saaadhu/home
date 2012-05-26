require 'active_record'

class Tobuy < ActiveRecord::Base

  self.primary_key= "id"

  validates :item_id, :presence => true
  validates :quantity, :numericality => true

  has_one :item
end
