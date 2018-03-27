# frozen_string_literal: true

require 'datasources/github'
require 'utils/cache'

module Repositories
  ##
  # Github issues and pull requests
  #
  class Issues
    include Utils::Cache

    ISSUES_TTL = 60 * 60

    def find_issues_by_repo(repository_name, access_token:)
      key = cache_key('issues_by_repo', repository_name)
      load_from_cache(key, ttl: ISSUES_TTL) do
        github.find_issues_by_repo(
          repository_name,
          access_token: access_token
        )
      end
    end

    def find_labels_by_issue(repository_name, issue_number, access_token:)
      key = cache_key('labels_by_issue', repository_name, issue_number)
      load_from_cache(key) do
        github.find_labels_by_issue(
          repository_name,
          issue_number,
          access_token: access_token
        )
      end
    end

    def find_comments_by_issue(repository_name, issue_number, access_token:)
      key = cache_key('comments_by_issue', repository_name, issue_number)
      load_from_cache(key) do
        github.find_comments_by_issue(
          repository_name,
          issue_number,
          access_token: access_token
        )
      end
    end

    private

    def github
      @github ||= Datasources::Github::Issues.new
    end
  end
end
