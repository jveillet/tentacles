# frozen_string_literal: true

require 'repositories/repositories'

module Helpers
  ##
  # Repositories helper
  #
  module Repositories
    def find_issues(repo)
      github_issues.find_issues_by_repo(
        repo, access_token: access_token
      )
    end

    def count_pull_requests_per_repo(pull_requests_groups)
      pull_requests_per_repo = {}
      pull_requests_groups.each do |pull_requests|
        pull_requests.each do |pull_request|
          repo_name = pull_request.to_h.dig(:head, :repo, :name)

          if pull_requests_per_repo.key?(repo_name)
            pull_requests_per_repo [repo_name] += 1
          else
            pull_requests_per_repo [repo_name] = 1
          end
        end
      end
      pull_requests_per_repo
    end

    def find_closed_issues_and_comments_by_repo(repo)
      issues = github_issues.find_closed_issues_by_repo(
        repo, access_token: access_token
      )
      issues.to_a.map do |issue|
        comments = github_issues.find_comments_by_issue(
          repo,
          issue[:number],
          access_token: access_token
        )
        issue[:comments_count] = comments.count
        issue
      end
    end

    def find_repo_and_total_number_of_comments(pull_requests)
      repo_name = nil
      total_number_of_comments = 0
      pull_requests.each do |pull_request|
        repo_name = pull_request.to_h.dig(:head, :repo, :name)
        number_of_comments_per_pr = pull_request.to_h[:comments_count]
        total_number_of_comments += number_of_comments_per_pr
      end
      [repo_name, total_number_of_comments]
    end

    def compute_lifetime_sum(pull_requests)
      pull_request_number, lifetime_sum, repo_name = 0, 0
      pull_requests.each do |pull_request|
        creation_date = pull_request.to_h[:created_at]
        closure_date = pull_request.to_h[:closed_at]
        repo_name = pull_request.to_h.dig(:head, :repo, :name)
        lifetime_pullrequest = (closure_date - creation_date)
        lifetime_sum += lifetime_pullrequest
        pull_request_number += 1
      end
      [repo_name, lifetime_sum, pull_request_number]
    end

    def compute_counts(pull_requests_groups)
      count_hash = {}
      pull_requests_groups.each do |pull_requests|
        next unless pull_requests && !pull_requests.empty?
        count_hash[find_repo_and_total_number_of_comments(pull_requests)[0]] =
          find_repo_and_total_number_of_comments(pull_requests)[1]
      end
      count_hash
    end
  end
end
