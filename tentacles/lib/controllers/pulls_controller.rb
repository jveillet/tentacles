# frozen_string_literal: true

require 'helpers/users'
require 'helpers/repositories'
require 'repositories/issues'
require_relative 'application_controller'

module Controllers
  ##
  # Class Pull requests
  #
  class PullsController < ApplicationController
    helpers Helpers::Users
    helpers Helpers::Repositories
    helpers do
      def users
        @users ||= Repositories::User.new
      end

      def repositories
        @repositories ||= Repositories::Repositories.new
      end

      def github_issues
        @github_issues ||= Repositories::Issues.new
      end
    end
    before do
      logout unless current_user
    end

    post '/pulls' do
      pull_requests_groups = []

      params[:repos].each do |repo|
        next unless repo && !repo.empty?
        issues = find_issues(repo)
        pull_requests_groups << issues unless !issues || issues.empty?
      end

      pr_per_repo = count_pull_requests_per_repo(pull_requests_groups)

      erb :pulls, locals: {
        pull_request: pull_requests_groups,
        user: current_user,
        pull_requests_per_repo: pr_per_repo
      }
    end
  end
end
