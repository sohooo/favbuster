#!/usr/bin/ruby

# FavBuster Script -----------  by Sven Sporer 2010
# This script deals with the initial authorization of Favbuster.
#
# ----------------------------------------------------------------------
# AUTH CODE - INITIAL AUTH
# ----------------------------------------------------------------------
# This code only gets executed the first time to get the access token
# and access secret (to put in config file)

# These credentials are specific to your *application* and not your *user*
# Get these credentials from Twitter directly: http://twitter.com/apps
#
CONFIG_FILE = File.expand_path("../config.yaml", __FILE__)
CONFIG = YAML::load(File.read(CONFIG_FILE))

consumer_key    = CONFIG['oauth']['consumer_key']
consumer_secret = CONFIG['oauth']['consumer_secret']
 
oauth = Twitter::OAuth.new(consumer_key, consumer_secret)
 
request_token  = oauth.request_token.token
request_secret = oauth.request_token.secret

puts "Request token => #{request_token}"
puts "Request secret => #{request_secret}"
puts "Authentication URL => #{oauth.request_token.authorize_url}"
 
print "Provide the PIN that Twitter gave you here: "
pin = gets.chomp
 
oauth.authorize_from_request(request_token,request_secret,pin)
access_token  = oauth.access_token.token
access_secret = oauth.access_token.secret
puts "Access token =>  #{oauth.access_token.token}"
puts "Access secret => #{oauth.access_token.secret}"
 
oauth.authorize_from_access(access_token, access_secret)
twitter = Twitter::Base.new(oauth)
puts twitter.friends_timeline(:count => 1)
