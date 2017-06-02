require 'sinatra/base'
require 'tentacles/controllers/base'
require 'tentacles/repositories/user'

module Tentacles
  module Controllers
    ##
    # Class Authentication
    #
    class Authentication < Base
      helpers do
        def users
          @users ||= Tentacles::Repositories::User.new
        end
      end
      get '/callback' do
        session_code = (request.env['rack.request.query_hash'] || {})['code']
        error!('Unauthorized', 401) unless session_code
        access_token = users.authorize_with_code(session_code)

        session[:access_token] = access_token

        redirect '/repositories'
      end
    end
  end
end
