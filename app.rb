# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "geocoder"                                                                    #
require "bcrypt"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################

restaurants_table = DB.from(:restaurants)
users_table = DB.from(:users)
ratings_table = DB.from(:ratings)

before do  
    @current_user = users_table.where(:id => session[:user_id]).to_a[0]
    puts @current_user.inspect
end

# Home Page
get "/" do
    view 'home'
end

get "/talia" do
    @lat_long = "40.441260, -79.996794"
    @avg_talia_rating = ratings_table.where(:name=>"Talia").avg(:rating)
    @restaurant = "Talia"
    view 'talia'
end

# receiving new rating for Talia
post "/ratings/create/talia" do
    puts params.inspect
    ratings_table.insert(:name => "Talia", :rating => params["rating"])
    view 'talia'
# kind of sketchy experience because page continues to display but without new avg rating - following MVP launch, would cause page to refresh and rating submission to be hidden and instead display a thank you for your rating message
end

get "/dianoias" do
    @avg_dianoias_rating = ratings_table.where(:name=>"DiAnoia's").avg(:rating)
    @restaurant = "DiAnoia's"
    view 'dianoias'
end

# receiving new rating for DiAnoia's
post "/ratings/create/dianoias" do
    puts params.inspect
    ratings_table.insert(:name => "DiAnoia's", :rating => params["rating"])
    view 'dianoias'
end

get "/alta-via" do
    # results = Geocoder.search("46 Fox Chapel Rd, Pittsburgh, PA 15238")
    @lat_long = "40.488354, -79.882596"
    @avg_alta_via_rating = ratings_table.where(:name=>"Alta Via").avg(:rating)
    @restaurant = "Alta Via"
    view 'alta-via'
end

# receiving new rating for Alta Via
post "/ratings/create/alta-via" do
    puts params.inspect
    ratings_table.insert(:name => "Alta Via", :rating => params["rating"])
    view 'alta-via'
end

get "/coca-cafe" do
    @avg_coca_cafe_rating = ratings_table.where(:name=>"Coca Cafe").avg(:rating)
    @restaurant = "Coca Cafe"
    view 'coca-cafe'
end

# receiving new rating for Coca Cafe
post "/ratings/create/coca-cafe" do
    puts params.inspect
    ratings_table.insert(:name => "Coca Cafe", :rating => params["rating"])
    view 'coca-cafe'
end

get "/girasole" do
    @avg_girasole_rating = ratings_table.where(:name=>"Girasole").avg(:rating)
    @restaurant = "Girasole"
    view 'girasole'
end

# receiving new rating for Girasole
post "/ratings/create/girasole" do
    puts params.inspect
    ratings_table.insert(:name => "Girasole", :rating => params["rating"])
    view 'girasole'
end

get "/smiling-banana-leaf" do
    @avg_smiling_banana_leaf_rating = ratings_table.where(:name=>"Smiling Banana Leaf").avg(:rating)
    @restaurant = "Smiling Banana Leaf"
    view 'smiling-banana-leaf'
end

# receiving new rating for Smiling Banana Leaf
post "/ratings/create/smiling-banana-leaf" do
    puts params.inspect
    ratings_table.insert(:name => "Smiling Banana Leaf", :rating => params["rating"])
    view 'smiling-banana-leaf'
end

get "/dinette" do
    @avg_dinette_rating = ratings_table.where(:name=>"Dinette").avg(:rating)
    @restaurant = "Dinette"
    view 'dinette'
end

# receiving new rating for Dinette
post "/ratings/create/dinette" do
    puts params.inspect
    ratings_table.insert(:name => "Dinette", :rating => params["rating"])
    view 'dinette'
end

get "/sign-up" do
    view 'sign-up'
end

# When new user signs up
post "/users/create" do
    puts params.inspect
    users_table.insert(:name => params["name"], :email => params["email"], :password => BCrypt::Password.create(params["password"]))
    view '/create_user'
end

get "/log-in" do
    view 'log-in'
end

get "/log-out" do
    session[:user_id] = nil
    view 'log-out'
end
