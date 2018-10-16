# frozen_string_literal: true

require 'helpers/users'
require 'helpers/repositories'
require 'repositories/repositories'
require 'repositories/issues'
require_relative 'application_controller'

module Controllers
  ##
  # Class Repositories
  #
  class DashboardController < ApplicationController
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

      def visibility(params)
        return 'all' unless params
        result = if %w[public private].include? params[:visibility]
                   params[:visibility]
                 else
                   'all'
                 end
        result
      end

      def find_issues_key(repo_key)
        github_issues.find_issues_by_repo(
          repo_key, access_token: access_token
        )
      end
    end

    before do
      logout unless current_user
    end

    get '/dashboard' do
      display_filter = visibility(params)
      pull_requests_groups = []

      repos = repositories.find_repositories_by_user(
        current_user,
        visibility_filter: display_filter,
        access_token: access_token
      )

      repos.each do |repo|
        next unless repo && !repo.empty?
        repo_key = repo[:id]
        issues = find_issues_key(repo_key)
        pull_requests_groups << issues unless !issues || issues.empty?
      end

      pr_per_repo = count_pull_requests_per_repo(pull_requests_groups)

      erb :dashboard, locals: {
        user: current_user,
        repos: repos,
        pull_request: pull_requests_groups,
        pull_requests_per_repo: pr_per_repo
      }
    end
  end
end
