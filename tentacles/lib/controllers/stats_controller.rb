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
      mm, ss = seconds.divmod(60)
      hh, mm = mm.divmod(60)
      dd, hh = hh.divmod(24)
      puts '%d days, %d hours, %d minutes and %d seconds' % [dd, hh, mm, ss]
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
        pull_requests_groups << issues
      end

      pull_requests_groups.each do |pull_requests|
        pull_request_number = 0
        lifetime_sum = 0
        pull_requests.each do |pull_request|
          creation_date = pull_request.to_h.dig(:created_at)
          closure_date = pull_request.to_h.dig(:closed_at)
          lifetime_pullrequest = closure_date - creation_date
          lifetime_sum += lifetime_pullrequest
          pull_request_number += 1
        end
        average_lifetime = lifetime_sum / pull_request_number
        average_per_repo = seconds_to_units(average_lifetime)
      end
      erb :stats, locals: {
        pull_request: pull_requests_groups,
        user: current_user,
        average: average_per_repo
      }
    end
  end
end
