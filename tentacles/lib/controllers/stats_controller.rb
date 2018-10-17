# frozen_string_literal: true

require 'helpers/users'
require 'helpers/repositories'
require 'repositories/issues'
require_relative 'application_controller'

module Controllers
  ##
  # Class Pull requests
  #
  class StatsController < ApplicationController
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

      def seconds_to_days(seconds)
        mm, _ss = seconds.divmod(60)
        hh, _mm = mm.divmod(60)
        dd, _hh = hh.divmod(24)
        dd
      end
    end

    before do
      logout unless current_user
    end

    get '/stats' do
      pull_requests_groups = []

      selected_repos!.each do |repo|
        next unless repo && !repo.empty?
        issues = find_closed_issues_and_comments_by_repo(repo)
        pull_requests_groups << issues unless !issues || issues.empty?
      end

      count_hash = compute_counts(pull_requests_groups)

      average_hash = {}

      pull_requests_groups.each do |pull_requests|
        next unless pull_requests && !pull_requests.empty?
        lifetime_in_seconds = (
          compute_lifetime_sum(pull_requests)[1] / compute_lifetime_sum(pull_requests)[2]
        )
        lifetime_in_days = seconds_to_days(lifetime_in_seconds)
        average_hash[compute_lifetime_sum(pull_requests)[0]] = lifetime_in_days
      end

      erb :stats, locals: {
        pull_request: pull_requests_groups,
        user: current_user,
        average: average_hash,
        count: count_hash
      }
    end
  end
end
