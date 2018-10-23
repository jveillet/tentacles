# frozen_string_literal: true

require_relative 'connection'
require_relative 'pagination'

module Datasources
  module Github
    ##
    # Github Commit Statuses datasource
    #
    class Statuses
      include Connection

      PER_PAGE = Integer(ENV['DEFAULT_PER_PAGE'] || 100)

      def check_status(repo, sha, options = {})
        return unless options[:access_token] && sha
        client(options[:access_token]).statuses(repo, sha)
      end
    end
  end
end
