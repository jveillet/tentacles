require 'dotenv'
require 'require_all'
require 'rack/session/redis'

ENV['SINATRA_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

require_all 'app'

use Rack::Session::Redis,
    :redis_server => "#{ENV.fetch('REDIS_URL')}/0/rack:session"

use Controllers::AuthenticationController
use Controllers::RepositoriesController
use Controllers::PullsController

run ApplicationController
