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

get "/alta-via" do
    # results = Geocoder.search("46 Fox Chapel Rd, Pittsburgh, PA 15238")
    @lat_long = "40.488354, -79.882596"
    @avg_alta_via_rating = ratings_table.where(:name=>"Alta Via").avg(:rating)
    view 'alta-via'
end

# receiving new rating for Alta Via
post "/ratings/create" do
    puts params.inspect
    ratings_table.insert(:name => "Alta Via", :rating => params["rating"])
    view 'alta-via'
# kind of sketchy experience because page continues to display but without new avg rating - following MVP launch, would cause page to refresh and rating submission to be hidden and instead display a thank you for your rating message
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
