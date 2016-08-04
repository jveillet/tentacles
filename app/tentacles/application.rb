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
    CLIENT_ID = ENV['GH_CLIENT_ID']
    CLIENT_SECRET = ENV['GH_CLIENT_SECRET']

    use Rack::Session::Pool, :cookie_only => false
    helpers Helpers::State

    def authenticated?
      session[:access_token]
    end

    def authenticate!
      erb :index, :locals => {:client_id => CLIENT_ID, :state => generate_state }
    end

    get '/' do
      if !authenticated?
        authenticate!
      else
        access_token = session[:access_token]

        begin
          client = Octokit::Client.new(:access_token => access_token)
        rescue => e
          # request didn't succeed because the token was revoked so we
          # invalidate the token stored in the session and render the
          # index page so that the user can start the OAuth flow again

          session[:access_token] = nil
          session.clear
          return authenticate!
        end

        session[:user] = client.user
        repositories = client.repositories

        erb :tentacles, :locals => { :user => client.user, :repos => repositories }
      end
    end

    get '/callback' do
      session_code = request.env['rack.request.query_hash']['code']

      result = RestClient.post('https://github.com/login/oauth/access_token',
                               {
                                 :client_id => CLIENT_ID,
                                 :client_secret => CLIENT_SECRET,
                                 :code => session_code
                               },
                               :accept => :json)

      session[:access_token] = JSON.parse(result)['access_token']
      redirect '/'
    end

    post '/pull' do
      client = Octokit::Client.new(:access_token => session[:access_token])

      pull_requests = []
      params.each do |k, _v|
        pull_requests << client.pull_requests(k)
      end
      erb :pull, :locals => { :pull_request => pull_requests }
    end
  end
end
