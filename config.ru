require 'bundler'
require 'dotenv'
require 'rack'
require 'sinatra'
require 'sinatra/base'
require 'rack/session/redis'

Dotenv.load

use Rack::Session::Redis,
    :redis_server => "#{ENV.fetch('REDIS_URL')}/0/rack:session"

Bundler.setup(:default)
$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/app")

require 'tentacles'

url_map = {
  '/' => Tentacles::Application,
  '/authentication' => Tentacles::Controllers::Authentication.new,
  '/repositories' => Tentacles::Controllers::Repositories.new,
  '/pulls' => Tentacles::Controllers::Pulls.new
}

run Rack::URLMap.new url_map
