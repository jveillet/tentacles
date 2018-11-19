# frozen_string_literal: true

require 'helpers/repositories'
require 'repositories/repositories'
require 'repositories/commits'
require 'repositories/issues'
require 'models/commit'
require_relative 'application_controller'

module Controllers
  ##
  # Class Diff
  #
  class DiffController < ApplicationController
    helpers Helpers::Users
    helpers Helpers::Repositories
    helpers do
      def repositories
        @repositories ||= Repositories::Repositories.new
      end

      def commits_repo
        @commits_repo ||= Repositories::Commits.new
      end

      def users
        @users ||= Repositories::User.new
      end

      def find_commits(repo, branch)
        commits = commits_repo.find_by_repo_and_branch(repo, branch,
                                                         access_token: access_token)
        commits.reject { |commit|
          commit.commit.message.start_with? 'Merge pull request #' }.map { |commit|
            Models::Commit.new(commit) }
      end

      def similar?(qa_commit, staging_commit)
        (staging_commit.jira_ids & qa_commit.jira_ids).size > 0
      end

      def message_based_diff(left_commits, right_commits)
        right_commit_messages = right_commits.map(&:message)
        left_commits.select do |commit|
          !right_commit_messages.include?(commit.message)
        end
      end

      def complete_with_similars!(commits_to_complete, right_commits)
        commits_to_complete.each do |commit|
          unless commit.jira_ids&.empty?
            commit.similars =
              right_commits.select { |right_commit| similar?(commit, right_commit) }.map(&:message)
          end
        end
      end
    end

    before do
      logout unless current_user
    end

    get '/diff' do

      repos = repositories.find_repositories_by_user(
        current_user,
        visibility_filter: 'all',
        access_token: access_token
      )

      repo = params[:repo] # 'WEForum/fws-search'
      left_branch = params[:left_branch] #'qa'
      right_branch = params[:right_branch] #'staging'

      diff_commits = []

      if repo && left_branch && right_branch
        left_branch_commits = find_commits(repo, left_branch)
        right_branch_commits = find_commits(repo, right_branch)

        diff_commits = message_based_diff(
          left_branch_commits,
          right_branch_commits
        )

        complete_with_similars!(diff_commits, right_branch_commits)
      end

      erb :diff, locals: {
        user: current_user,
        repos: repos,
        commits: diff_commits
      }, layout: :tentacles_layout
    end
  end
end
