# frozen_string_literal: true

module Datasources
  module Github
    ##
    # Github Commits datasource
    #
    class Commits
      include Connection

      PER_PAGE = Integer(ENV['DEFAULT_PER_PAGE'] || 100)

      def find_by_repo_and_branch(repo, branch, access_token: )
        github = client(access_token)
        records = github.commits(
          repo,
          branch,
          per_page: PER_PAGE
        )
        return [] unless records
        pagination = Pagination.new(records)
        pagination.next_pages(github.last_response)
      end
    end
  end
end
