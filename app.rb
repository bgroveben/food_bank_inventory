require "sinatra"
require "sinatra/activerecord"
 
set :database, "sqlite3:///inventory.db"
 
class Post < ActiveRecord::Base
end