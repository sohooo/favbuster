# FavBuster Script -----------  by Sven Sporer 2011
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
require "highline/import"
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


# Just some methods to style (colors, underline links) text. 
def c(text, style); "<%= color('#{text}', #{style})%> "; end

def style(text)
  styled = ""
  text.split.each do |phrase|
    case 
    when phrase.match(/^http/) then styled += c(phrase, "UNDERLINE")
    when phrase.match(/^@/)    then styled += c(phrase, ":yellow")
    when phrase.match(/^#/)    then styled += c(phrase, ":red")
    else
      styled += phrase + " "
    end
  end

  styled
end


# Start cleaning up the favorites list.
client = Twitter::Client.new
client.favorites.each do |fav|
  Twitter.favorite_destroy(fav.id)
  say("<%= color('#{fav.user.screen_name}', :green) %>: #{style(fav.text)}\n")
end

# Currently, Twitter only allows to delete 20 favs at a time.
# We check again in order to call the script again.
while client.favorites.size > 0
  system("ruby", __FILE__)
end
