require 'rubygems'
require 'sinatra'
require 'active_record'
require 'item'
require 'tobuy'
require 'tag'
require 'haml'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :dbfile =>'db/home.db', :database => 'db/home.db')

get '/' do
  @tags = Tag.all
  haml :index
end

get '/item/new' do
  haml :'items/new'
end

post '/item/tobuy' do
  @tobuy = Tobuy.new
  item = Item.find_by_name(params[:item_name])

  if item
    @tobuy.item_id = item.id
    @tobuy.quantity = params[:quantity]
  
    if @tobuy.save 
      "Saved"
    else
      @tobuy.errors.to_xml
    end
  else
    "No such item!"
  end
end

post '/item/new' do
  @item = Item.save_new_item(params[:name], params[:tags])
  haml :'items/new'
end
