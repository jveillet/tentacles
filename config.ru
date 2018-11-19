# frozen_string_literal: true

require 'dotenv/load'
require 'rack'
require 'rack/session/redis'

ENV['APP_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require(:default, ENV['APP_ENV'])

use Rack::Session::Redis,
    redis_server: "#{ENV.fetch('REDIS_URL')}/0/rack:session",
    pool_size: 5,
    pool_timeout: 15,
    expire_after: 28_800 # 8h

$LOAD_PATH.unshift(
  File.join(File.dirname(__FILE__), 'tentacles/lib')
)

require 'controllers/application_controller'
require 'controllers/authentication_controller'
require 'controllers/dashboard_controller'
require 'controllers/diff_controller'
require 'controllers/repositories_controller'
require 'controllers/pulls_controller'
require 'controllers/stats_controller'

use Controllers::AuthenticationController
use Controllers::DashboardController
use Controllers::DiffController
use Controllers::RepositoriesController
use Controllers::PullsController
use Controllers::StatsController
use Rack::Deflater

run Controllers::ApplicationController
