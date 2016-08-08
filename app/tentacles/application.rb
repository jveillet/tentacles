require 'sinatra/base'
require 'octokit'
require 'tentacles/helpers'

##
#
#
module Tentacles
  ##
  #
  #
  class Application < Sinatra::Base
    use Rack::Session::Pool, :cookie_only => false
    helpers Helpers::State

    get '/' do
      erb :index, :locals => {:client_id => ENV['GH_CLIENT_ID'], :state => generate_state }
    end
  end
end
