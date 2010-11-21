#!/usr/bin/ruby

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
require "twitter"

# ----------------------------------------------------------------------
# AFTER SUCCESSFUL AUTH
# ----------------------------------------------------------------------

CONFIG_FILE = File.expand_path("../config.yaml", __FILE__)
CONFIG = YAML::load(File.read(CONFIG_FILE))

consumer_key    = CONFIG['oauth']['consumer_key']
consumer_secret = CONFIG['oauth']['consumer_secret']
access_token    = CONFIG['oauth']['access_token']
access_secret   = CONFIG['oauth']['access_secret']

oauth = Twitter::OAuth.new(consumer_key, consumer_secret)

oauth.authorize_from_access(access_token, access_secret)
twitter = Twitter::Base.new(oauth)

puts "deleting the following tweets:"
twitter.favorites.each do |fav|
  puts "#{fav.user.screen_name.rjust(20)}: #{fav.text}"
  twitter.favorite_destroy(fav.id)
end
