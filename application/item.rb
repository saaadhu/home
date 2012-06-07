require 'active_record'

class Item < ActiveRecord::Base

  has_and_belongs_to_many :tags
  has_one :purchase
  validates_presence_of :name

  def Item.save_new_item(name, tags, quantity)
    i = Item.new()
    i.name = name
    i.typical_quantity = quantity
    i.save

    Item.attach_tag_objs(i, tags)

    i.save!
    return i
  end

  def Item.attach_tag_objs(item, tags)
      tags.split.each do |tag_name|
        tag = Tag.find_by_name(tag_name)
        if !tag:
          tag = Tag.new
          tag.name = tag_name
	end
        item.tags << tag
      end
  end

  def Item.with_name_like (prefix)
    items = self.where("lower(name) like '#{prefix.downcase}%'")
    item_names = []

    items.each do |item|
      item_names << item.name
    end

    item_names
  end
end

