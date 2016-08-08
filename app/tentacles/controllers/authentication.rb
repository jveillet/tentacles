require 'sinatra/base'
require 'tentacles/controllers/base'

module Tentacles
  module Controllers
    ##
    # Class Authentication
    #
    class Authentication < Base
      get '/callback' do
        session_code = request.env['rack.request.query_hash']['code']

        result = RestClient.post('https://github.com/login/oauth/access_token',
                                 {
                                   :client_id => ENV['GH_CLIENT_ID'],
                                   :client_secret => ENV['GH_CLIENT_SECRET'],
                                   :code => session_code
                                 },
                                 :accept => :json)

        session[:access_token] = JSON.parse(result)['access_token']
        redirect '/repositories'
      end
    end
  end
end
