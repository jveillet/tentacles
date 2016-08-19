require 'sinatra/base'
require 'tentacles/controllers/base'
require 'tentacles/helpers/authentication'
require 'tentacles/helpers/client'
require 'uri'

module Tentacles
  module Controllers
    ##
    # Class Pull requests
    #
    class Pulls < Base
      helpers Helpers::Authentication
      helpers Helpers::Client

      before do
        logout unless authenticated?
      end

      post '/' do
        # Get every pull_requests with the repo name
        pull_requests = []
        params.each do |k, _v|
          pr = client.pull_requests(k)
          pull_requests << pr unless pr.nil? || pr.empty?
        end
        # loop throught pull requests to get the labels
        # add labels to the original hash
        pull_requests.each do |pr|
          next if pr.nil? || pr[0].nil?
          repo = pr[0][:head][:repo][:full_name]
          pr.each do |request|
            issue_number = request[:number]
            labels = client.labels_for_issue(repo, issue_number)
            request[:labels] = labels || {}
            # Get the comments as well
            comments = client.pull_request_comments(repo, issue_number)
            request[:comments_count] = comments.count
          end
        end

        erb :pulls, :locals => { :pull_request => pull_requests, :user => client.user }
      end
    end
  end
end
