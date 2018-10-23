# frozen_string_literal: true

require_relative 'connection'

module Datasources
  module Github
    ##
    # Github User datasource
    #
    class User
      include Connection

      def find_by_access_token(access_token)
        client(access_token).user
      rescue Octokit::ClientError => e
        $stderr.puts e.message
        nil
      end
    end
  end
end
