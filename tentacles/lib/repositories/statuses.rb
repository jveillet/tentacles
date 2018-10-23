# frozen_string_literal: true

require 'datasources/github/statuses'
require 'utils/cache'

module Repositories
  ##
  # Github Commit Statuses
  #
  class Statuses
    include Utils::Cache

    def check_status(repo, sha, options = {})
      statuses.check_status(repo, sha, options)
    end

    private

    def statuses
      @statuses ||= Datasources::Github::Statuses.new
    end
  end
end
