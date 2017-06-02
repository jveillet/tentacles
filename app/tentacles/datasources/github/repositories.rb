require 'tentacles/datasources/github/connection'

module Tentacles
  module Datasources
    module Github
      ##
      # Github Repositories datasource
      #
      class Repositories
        include Connection

        def initialize(access_token)
          @access_token = access_token
        end

        def find_repositories(visibility_filter)
          client(@access_token)
            .repositories(nil, :visibility => visibility_filter)
        end
      end
    end
  end
end
