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
      pull_requests = []

      params[:repos].each do |repo|
        next unless repo && !repo.empty?
        issues = github_issues.find_issues_by_repo(
          repo, access_token: access_token
        )
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

      first_cursor = 0
      final_hash = {}

      until first_cursor == pull_requests.length
        second_cursor = 0

        until second_cursor == pull_requests[first_cursor].length
          repo_name = pull_requests[first_cursor][second_cursor]
                      .to_h.dig(:head, :repo, :name)

          if final_hash.key?(repo_name)
            final_hash [repo_name] += 1
          else
            final_hash [repo_name] = 1
          end
          second_cursor += 1
        end
        first_cursor += 1
      end

      puts final_hash

      erb :pulls, locals: {
        pull_request: pull_requests,
        user: current_user,
        pull_requests_per_repo: final_hash
      }
    end
  end
end
