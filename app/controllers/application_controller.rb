require './app/helpers/state'
require 'octokit'
require 'sinatra/base'

##
# Base application controller
#
class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    set :logging, true
  end
  use Rack::Session::Pool, :cookie_only => false
  helpers Helpers::State

  get '/' do
    erb :index, :locals => {:client_id => ENV['GH_CLIENT_ID'], :state => generate_state }
  end
end
