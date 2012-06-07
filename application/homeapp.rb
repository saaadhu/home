require 'rubygems'
require 'sinatra'
require 'active_record'
require 'haml'
require 'json'

require 'item'
require 'tag'
require 'purchase'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :dbfile =>'db/home.db', :database => 'db/home.db')

get '/' do
  @tags = Tag.all
  haml :index
end

get '/webcam' do
  image_path = "/tmp/webcam_image.jpeg"
  File.delete(image_path) if File.exists? image_path
  %x[chmod g+rw /dev/video0]
  results = %x[export LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so && streamer -s 1280x960 -o #{image_path} 2>&1]
  if File.exists? image_path
    send_file image_path
  else
    results
  end
end

get '/item/search' do
  Item.with_name_like(params[:term]).to_json
end

get '/item/new' do
  haml :'items/new'
end

post '/item/new' do
  @item = Item.save_new_item(params[:name], params[:tags], params[:quantity])
  "Saved"
end

get '/tags/tobuy/:name' do
  @tag_name = params[:name]
  tag = Tag.find_by_name(@tag_name)

  @items = tag.items.find_all_by_should_buy(1)
  haml :'items/tobuy'
end

post '/item/tobuy' do
  item = Item.find_by_name(params[:item_name])
  if item.nil?
    return "No such item."
  end

  item.should_buy = 1

  if item.save 
    "Saved"
  else
    item.errors.to_xml
  end
end

get '/item/buy' do
  @item_name = params[:item_name]
  @quantity = params[:quantity]
  haml :'/items/buy'
end
  
post '/item/buy' do
  item_name = params[:item_name]
  quantity = params[:quantity]
  price = params[:price]
  
  @purchase = Purchase.new
  @purchase.item = Item.find_by_name(item_name)
  @purchase.item.should_buy = 0
  @purchase.quantity = quantity.to_i
  @purchase.price = price.to_f
  @purchase.timestamp = Time.now.to_i
  if @purchase.save
    @purchase.item.save
    "Saved"
  else
    item.errors.to_xml
  end
end
