require 'tentacles/datasources/github/repositories'

module Tentacles
  module Repositories
    ##
    # Github repository
    #
    class Repositories
      DEFAULT_VISIBILITY = 'all'.freeze

      def initialize(access_token)
        @access_token = access_token
      end

      def find_repositories(visibility_filter: DEFAULT_VISIBILITY)
        repositories.find_repositories(
          visibility_filter
        )
      end

      private

      def repositories
        @repositories ||=
          Tentacles::Datasources::Github::Repositories.new(@access_token)
      end
    end
  end
end
