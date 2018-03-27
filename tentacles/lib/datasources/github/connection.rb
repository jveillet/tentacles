# frozen_string_literal: true

require 'octokit'

module Datasources
  module Github
    ##
    # Github connection
    #
    module Connection
      def client(access_token)
        connect(access_token)
      end

      def response_success?
        client.last_response.status == 200
      end

      private

      def connect(access_token)
        @connect ||= Octokit::Client.new(
          access_token: access_token
        )
      end
    end
  end
end
