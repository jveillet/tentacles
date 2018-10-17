# frozen_string_literal: true

require 'helpers/state'
require 'sinatra/base'
require "sinatra/cookies"

module Controllers
  ##
  # Base application controller
  #
  class ApplicationController < Sinatra::Base
    configure do
      set :public_folder, 'public'
      set :views, 'tentacles/lib/views'
      set :logging, true
      set :session_secret, ENV['SESSION_SECRET'].to_s
    end

    helpers Helpers::State

    get '/' do
      erb :index, locals: {
        client_id: ENV['GH_CLIENT_ID'], state: generate_state
      }
    end

    not_found do
      erb :error_404
    end
  end
end
