require 'sinatra/base'
require 'tentacles/controllers/base'
require 'tentacles/helpers/authentication'
require 'uri'

module Tentacles
  module Controllers
    ##
    # Class Pull requests
    #
    class Pulls < Base

      helpers Helpers::Authentication

      before do
        redirect '/' unless authenticated?
      end

      post '/' do
        begin
          client = Octokit::Client.new(:access_token => session[:access_token])
        rescue => e
          # request didn't succeed because the token was revoked so we
          # invalidate the token stored in the session and render the
          # index page so that the user can start the OAuth flow again

          session[:access_token] = nil
          session.clear
          redirect '/'
        end

        # Get every pull_requests with the repo name
        pull_requests = []
        params.each do |k, _v|
          pull_requests << client.pull_requests(k)
        end
        # loop throught pull requests to get the labels
        # add labels to the original hash
        pull_requests.each do |pr|
          repo = pr[0][:head][:repo][:full_name]
          pr.each do |request|
            issue_number = request[:number]
            labels = client.labels_for_issue(repo, issue_number)
            request[:labels] = labels
          end
        end
        erb :pulls, :locals => { :pull_request => pull_requests, :user => client.user }
      end
    end
  end
end
