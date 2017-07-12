require_relative 'connection'
require_relative 'pagination'

module Datasources
  module Github
    ##
    # Github Repositories datasource
    #
    class Repositories
      include Connection

      PER_PAGE = Integer(ENV['DEFAULT_PER_PAGE'] || 100)

      def find_repositories(filter, access_token:, per_page: PER_PAGE)
        github = client(access_token)
        records = github.repositories(
          nil,
          :visibility => filter,
          :per_page => per_page
        )
        return [] unless records
        pagination = Pagination.new(records)
        pagination.next_pages(github.last_response)
      end
    end
  end
end
