require 'active_record'

class Tobuy < ActiveRecord::Base
  has_one :item
end
