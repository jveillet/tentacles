# frozen_string_literal: true

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

      def find_issues_by_repo(repository_name, access_token:)
        return [] unless repository_name
        begin
          records = client(access_token).pull_requests(repository_name)
          return [] if records.nil? || records.empty?
          records
        rescue Octokit::NotFound => e
          puts e.message
          []
        end
      end

      def find_labels_by_issue(repository_name, issue_number, access_token:)
        return [] unless repository_name
        begin
          labels = client(access_token).labels_for_issue(
            repository_name,
            issue_number
          )
          return [] if labels.nil? || labels.empty?
          labels
        rescue Octokit::NotFound => e
          puts e.message
          []
        end
      end

      def find_comments_by_issue(repository_name, issue_number, access_token:)
        return [] unless repository_name
        begin
          comments = client(access_token).pull_request_comments(
            repository_name,
            issue_number
          )
          return [] if comments.nil? || comments.empty?
          comments
        rescue Octokit::NotFound => e
          puts e.message
          []
        end
      end
    end
  end
end
