require 'helpers/users'
require 'repositories/issues'
require_relative 'application_controller'

module Controllers
  ##
  # Class Pull requests
  #
  class PullsController < ApplicationController
    helpers Helpers::Users
    helpers do
      def github_issues
        @github_issues ||= Repositories::Issues.new
      end
    end

    before do
      logout unless current_user
    end

    post '/pulls' do
      pull_requests = []

      params[:repos].each do |repo|
        next unless repo && !repo.empty?
        issues = github_issues.find_issues_by_repo(repo, access_token: access_token)
        next if !issues || issues.empty?
        issues.each do |issue|
          issue[:labels] = github_issues.find_labels_by_issue(
            repo,
            issue[:number],
            access_token: access_token
          )
          comments = github_issues.find_comments_by_issue(
            repo,
            issue[:number],
            access_token: access_token
          )
          issue[:comments_count] = comments.count
        end
        pull_requests << issues
      end

      erb :pulls, :locals => { :pull_request => pull_requests, :user => current_user }
    end
  end
end
