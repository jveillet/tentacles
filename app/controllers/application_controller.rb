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
    set :sessions, false
    set :session_secret, ENV['SESSION_SECRET'].to_s
  end
  helpers Helpers::State

  get '/' do
    erb :index, :locals => {:client_id => ENV['GH_CLIENT_ID'], :state => generate_state }
  end
end
