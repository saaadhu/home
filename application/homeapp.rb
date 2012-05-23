require 'rubygems'
require 'sinatra'
require 'active_record'
require 'item'
require 'tag'
require 'haml'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :dbfile =>'db/home.db', :database => 'db/home.db')

get '/' do
  haml :index
end

get '/item/new' do
  haml :'items/new'
end



post '/item/new' do
  @item = Item.save_new_item(params[:name], params[:tags])
  haml :'items/new'
end
