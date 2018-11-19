# frozen_string_literal: true

require 'datasources/github'
require 'utils/cache'

module Repositories
  ##
  # Github commits
  #
  class Commits
    include Utils::Cache

    def find_by_repo_and_branch(repo, branch, access_token: )
      key = cache_key('commits', repo, branch)
      load_from_cache(key) do
        commits.find_by_repo_and_branch(repo, branch,
                                        access_token: access_token)
      end
    end

    private

    def commits
      @commits ||= Datasources::Github::Commits.new
    end
  end
end
