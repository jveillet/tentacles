require 'sinatra/base'
require 'tentacles/controllers/base'
require 'tentacles/helpers/authentication'

module Tentacles
  module Controllers
    ##
    # Class Repositories
    #
    class Repositories < Base

      helpers Helpers::Authentication

      before do
        redirect '/' unless authenticated?
      end

      get '/' do
        access_token = session[:access_token]
        begin
          client = Octokit::Client.new(:access_token => access_token)
        rescue => e
          # request didn't succeed because the token was revoked so we
          # invalidate the token stored in the session and render the
          # index page so that the user can start the OAuth flow again

          session[:access_token] = nil
          session.clear
          redirect '/'
        end

        session[:user] = client.user
        repositories = client.repositories
        erb :repositories, :locals => { :user => client.user, :repos => repositories }
      end
    end
  end
end
