# # Static site using Rack (with expire headers and etag support)... great for hosting static sites on Heroku
# 
require "bundler/setup"

require 'rack/contrib'
require 'rack-rewrite'

use Rack::StaticCache, :urls => ['/images','/css','/favicon.ico', '/js', '/apple-touch-icon.png', 'robots.txt'], :root => "_site"
use Rack::ETag
use Rack::Rewrite do
  rewrite '/', '/index.html'  
  rewrite '/feed', '/atom.xml'
  rewrite %r{(.+/?)(\?.*)$}, '$1/index.html$2'
  rewrite %r{(.+/?)$}, '$1/index.html'
end

# Middleware
use Rack::ShowStatus      # Nice looking 404s and other messages
use Rack::ShowExceptions  # Nice looking errors

run Rack::URLMap.new( {
  "/" => Rack::Directory.new( "_site" )
} )