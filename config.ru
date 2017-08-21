require 'dotenv'
require 'rack'
require 'rack/session/redis'

ENV['SINATRA_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

use Rack::Session::Redis,
    redis_server: "#{ENV.fetch('REDIS_URL')}/0/rack:session",
    pool_size: 5,
    pool_timeout: 15,
    expire_after: 28_800 # 8h

require './app/controllers/application_controller'
require './app/controllers/authentication_controller'
require './app/controllers/repositories_controller'
require './app/controllers/pulls_controller'

use Controllers::AuthenticationController
use Controllers::RepositoriesController
use Controllers::PullsController
use Rack::Deflater

run Controllers::ApplicationController
