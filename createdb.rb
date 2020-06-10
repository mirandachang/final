# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

# Database schema - this should reflect your domain model
DB.create_table! :users do
  primary_key :id
  foreign_key :restaurant_id
  String :name
  String :email
  String :password
end
DB.create_table! :restaurants do
  primary_key :id
  String :name
  String :neighborhood
end
DB.create_table! :ratings do
  primary_key :id
  foreign_key :restaurant_id
  String :name
  Integer :rating
end

# Google Maps API key: AIzaSyDcs6tXk2TB6lHoFlkAlpVWEkpzMcd36os

# Insert initial (seed) data
restaurants_table = DB.from(:restaurants)
restaurants_table.insert(name: "Talia", neighborhood: "Downtown")
restaurants_table.insert(name: "DiAnoia's", neighborhood: "Strip District")
restaurants_table.insert(name: "Alta Via", neighborhood: "Fox Chapel")
restaurants_table.insert(name: "Coca Cafe", neighborhood: "Lawrenceville")
restaurants_table.insert(name: "Girasole", neighborhood: "Shadyside")
restaurants_table.insert(name: "Smiling Banana Leaf", neighborhood: "Highland Park")
restaurants_table.insert(name: "Dinette", neighborhood: "East Liberty")

ratings_table = DB.from(:ratings)
ratings_table.insert(name: "Alta Via", rating: 10)
ratings_table.insert(name: "Alta Via", rating: 8)
ratings_table.insert(name: "Talia", rating: 10)
ratings_table.insert(name: "DiAnoia's", rating: 10)
ratings_table.insert(name: "Coca Cafe", rating: 8)
ratings_table.insert(name: "Girasole", rating: 9)
ratings_table.insert(name: "Smiling Banana Leaf", rating: 7)
ratings_table.insert(name: "Smiling Banana Leaf", rating: 8)