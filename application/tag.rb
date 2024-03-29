require 'active_record'

class Tag < ActiveRecord::Base

  has_and_belongs_to_many :items
  validates_presence_of :name
end

