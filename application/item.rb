require 'active_record'

class Item < ActiveRecord::Base

  has_and_belongs_to_many :tags
  validates_presence_of :name

  def Item.save_new_item(name, tags)

	i = Item.new()
	i.name = name
	i.save

	tags.split.each do |tag_name|
i.tags.create(:name => tag_name)
	end

	i.save
	return i
   end
end

