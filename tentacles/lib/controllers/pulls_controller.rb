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

    get '/pulls' do
      pull_requests_groups = []

      selected_repos!.each do |repo|
        next unless repo && !repo.empty?
        issues = github_issues.find_issues_by_repo(repo, access_token: access_token)
        pull_requests_groups << issues unless !issues || issues.empty?
      end

      erb :pulls, locals: {
        pull_request: pull_requests_groups,
        user: current_user
      }, layout: :tentacles_layout
    end
  end
end
