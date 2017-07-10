require_relative 'connection'

module Datasources
  module Github
    ##
    # Github Repositories datasource
    #
    class Repositories
      include Connection

      def find_repositories(visibility_filter, access_token:)
        client(access_token)
          .repositories(nil, :visibility => visibility_filter)
      end
    end
  end
end
