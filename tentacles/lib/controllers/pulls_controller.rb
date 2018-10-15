# frozen_string_literal: true

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
      pull_requests_groups = []

      params[:repos].each do |repo|
        next unless repo && !repo.empty?
        issues = github_issues.find_issues_by_repo(
          repo, access_token: access_token
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

      erb :pulls, locals: {
        pull_request: pull_requests_groups,
        user: current_user,
        pull_requests_per_repo: final_hash
      }
    end
  end
end
