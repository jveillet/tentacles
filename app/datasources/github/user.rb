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
      end

      ##
      # Authenticate with oAuth2 flow against Github
      #
      # @param code [String] Authorization code
      #
      # @return access_token [String] oAuth2 access token
      #
      def authorize_with_code(code)
        result = RestClient.post(
          ENV['GITHUB_OAUTH_URL'],
          {
            :client_id => ENV['GH_CLIENT_ID'],
            :client_secret => ENV['GH_CLIENT_SECRET'],
            :code => code
          },
          :accept => :json
        )
        return unless result && result['access_token']
        JSON.parse(result)['access_token']
      end
    end
  end
end
