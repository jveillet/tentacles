# frozen_string_literal: true

require 'helpers/users'
require 'repositories/issues'
require_relative 'application_controller'

module Controllers
  ##
  # Class Pull requests
  #
  class StatsController < ApplicationController
    helpers Helpers::Users
    helpers do
      def github_issues
        @github_issues ||= Repositories::Issues.new
      end
    end

    before do
      logout unless current_user
    end

    def seconds_to_units(seconds)
      mm, _ss = seconds.divmod(60)
      hh, _mm = mm.divmod(60)
      dd, _hh = hh.divmod(24)
      dd
    end

    post '/stats' do
      pull_requests_groups = []

      params[:repos].each do |repo|
        next unless repo && !repo.empty?
        issues = github_issues.find_closed_issues_by_repo(
          repo, access_token: access_token
        )
        next if !issues || issues.empty?
        issues.each do |issue|
          comments = github_issues.find_comments_by_issue(
            repo,
            issue[:number],
            access_token: access_token
          )
          issue[:comments_count] = comments.count
        end
        pull_requests_groups << issues
      end

      count_hash = {}
      total_number_of_comments = 0

      pull_requests_groups.each do |pull_requests|
        next unless pull_requests && !pull_requests.empty?
        repo_name = nil
        pull_requests.each do |pull_request|
          repo_name = pull_request.to_h.dig(:head, :repo, :name)
          number_of_comments_per_pr = pull_request.to_h.dig(:comments_count)
          total_number_of_comments += number_of_comments_per_pr
        end
        count_hash[repo_name] = total_number_of_comments
      end

      average_hash = {}

      pull_requests_groups.each do |pull_requests|
        next unless pull_requests && !pull_requests.empty?
        pull_request_number, lifetime_sum, repo_name = 0, 0
        pull_requests.each do |pull_request|
          creation_date = pull_request.to_h.dig(:created_at)
          closure_date = pull_request.to_h.dig(:closed_at)
          repo_name = pull_request.to_h.dig(:head, :repo, :name)
          lifetime_pullrequest = (closure_date - creation_date)
          lifetime_sum += lifetime_pullrequest
          pull_request_number += 1
        end
        average_lifetime = (lifetime_sum / pull_request_number)
        average_per_repo = seconds_to_units(average_lifetime)
        average_hash[repo_name] = average_per_repo
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
