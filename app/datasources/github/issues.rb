require_relative 'connection'
require_relative 'pagination'

module Datasources
  module Github
    ##
    # Github Issues datasource
    #
    class Issues
      include Connection

      PER_PAGE = Integer(ENV['DEFAULT_PER_PAGE'] || 100)

      def find_issues_by_repo(repository_name, access_token:,
                              per_page: PER_PAGE)
        records = client(access_token).pull_requests(repository_name)
        return [] if records.nil? || records.empty?
        records
      end

      def find_labels_by_issue(repository_name, issue_number, access_token:)
        labels = client(access_token).labels_for_issue(
          repository_name,
          issue_number
        )
        return [] if labels.nil? || labels.empty?
        labels
      end

      def find_comments_by_issue(repository_name, issue_number, access_token:)
        comments = client(access_token).pull_request_comments(
          repository_name,
          issue_number
        )
        return [] if comments.nil? || comments.empty?
        comments
      end
    end
  end
end
