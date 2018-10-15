# frozen_string_literal: true

require 'helpers/users'
require 'repositories/repositories'
require 'repositories/issues'
require_relative 'application_controller'

module Controllers
  ##
  # Class Repositories
  #
  class RepositoriesController < ApplicationController
    helpers Helpers::Users
    helpers do
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
    end

    before do
      logout unless current_user
    end

    get '/repositories' do
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
        issues = github_issues.find_issues_by_repo(
          repo_key, access_token: access_token
        )
        pull_requests_groups << issues
      end

      final_hash = {}

      pull_requests_groups.each do |pull_requests|
        pull_requests.each do |pull_request|
          repo_name = pull_request.to_h.dig(:head, :repo, :name)

          if final_hash.key?(repo_name)
            final_hash [repo_name] += 1
          else
            final_hash [repo_name] = 1
          end
        end
      end

      erb :repositories, locals: {
        user: current_user,
        repos: repos,
        pull_request: pull_requests_groups,
        pull_requests_per_repo: final_hash
      }
    end
  end
end
