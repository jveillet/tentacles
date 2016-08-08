require 'bundler'
require 'dotenv'
require 'rack'
require 'sinatra/base'

Bundler.setup(:default)
$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/app")

Dotenv.load

require 'tentacles'

url_map = {
  '/' => Tentacles::Application,
  '/authentication' => Tentacles::Controllers::Authentication.new,
  '/repositories' => Tentacles::Controllers::Repositories.new,
  '/pulls' => Tentacles::Controllers::Pulls.new
}

run Rack::URLMap.new url_map
