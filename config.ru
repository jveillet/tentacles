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


files = Dir[File.dirname(__FILE__) + '/tentacles/lib/controllers/*']
files.each { |file| require file }

use Controllers::AuthenticationController
use Controllers::DashboardController
use Controllers::RepositoriesController
use Controllers::PullsController
use Controllers::StatsController
use Controllers::StatusesController
use Rack::Deflater

run Controllers::ApplicationController
