require 'active_record'

class Tobuy < ActiveRecord::Base

  has_one :item
  self.primary_key= "id"

  validates :item, :presence => true
  validates :quantity, :numericality => true

  has_one :item
end
