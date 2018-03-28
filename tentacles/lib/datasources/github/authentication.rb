# frozen_string_literal: true

require 'json'

module Datasources
  module Github
    ##
    # Github Oauth Authentication datasource
    #
    class Authentication
      ##
      # Authenticate with oAuth2 flow against Github
      #
      # @param code [String] Authorization code
      #
      # @return access_token [String] oAuth2 access token
      #
      def authenticate_with_code(code)
        result = RestClient.post(
          ENV['GITHUB_OAUTH_URL'],
          {
            client_id: ENV['GH_CLIENT_ID'],
            client_secret: ENV['GH_CLIENT_SECRET'],
            code: code
          },
          accept: :json
        )
        return unless result && result['access_token']
        JSON.parse(result)['access_token']
      end
    end
  end
end
