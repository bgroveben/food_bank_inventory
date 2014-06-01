require 'sinatra'
require 'data_mapper'
require 'slim'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/inventory.db")

class Item
  include DataMapper::Resource
  property :id, Serial
  property :content, Text, :required => true
  property :quantity, Text, :required => true
  property :done, Boolean, :required => true, :default => false
  property :created, DateTime
end
DataMapper.finalize.auto_upgrade!

get '/?' do
  @items = Item.all(:order => :created.desc)
  redirect '/new' if @items.empty?
  erb :index
end

get '/new/?' do
  @title = "Hello world, this is Ye Ole' Food Pantry!"
  erb :new
end

post '/new/?' do
  Item.create(:content => params[:content], :quantity => params[:quantity], :created => Time.now)
  redirect '/'
end

get '/delete/:id/?' do
  @item = Item.first(:id => params[:id])
  erb :delete
end

post '/delete/:id/?' do
  if params.has_key?("ok")
    item = Item.first(:id => params[:id])
    item.destroy
    redirect '/'
  else
    redirect '/'
  end
end

get '/more/*' do
	params[:splat].inspect
end

get '/form' do
	erb :form
end

post '/form' do
	# "you posted something"
	"You said '#{params[:message]}'"
end

get '/*' do
	status 404
	'not found'
end

get '/confirm' do
  session[:message] = 'Hello World!'
  redirect to('/views/confirm')
end

