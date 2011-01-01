# FavBuster Script -----------  by Sven Sporer 2010
# This script deletes all tweets marked as favorites.
# ---------------------------------------------------
# Usage:
#   1) First, call initial_auth.rb to get the access token and secret.
#   2) Create a config.yaml with the following content:
#
#         oauth:
#           consumer_key: "<consumer key>"
#           consumer_secret: "<consumer secret>"
#           access_token: <access token from initial_auth.rb>
#           access_secret: <access secret from initial_auth.rb>

require "rubygems"
require "bundler/setup"
require "twitter"

# ----------------------------------------------------------------------
# AFTER SUCCESSFUL AUTH
# ----------------------------------------------------------------------

CONFIG_FILE = File.expand_path("../config.yaml", __FILE__)
CONFIG = YAML::load(File.read(CONFIG_FILE))

Twitter.configure do |config|
  config.consumer_key       = CONFIG['oauth']['consumer_key']
  config.consumer_secret    = CONFIG['oauth']['consumer_secret']
  config.oauth_token        = CONFIG['oauth']['access_token']
  config.oauth_token_secret = CONFIG['oauth']['access_secret']
end

client = Twitter::Client.new

puts "deleting the following tweets:"
client.favorites.each do |fav|
  puts "#{fav.user.screen_name.rjust(20)}: #{fav.text}"
  twitter.favorite_destroy(fav.id)
end
