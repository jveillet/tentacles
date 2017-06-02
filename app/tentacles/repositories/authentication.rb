require 'tentacles/datasources/github/authentication'

module Tentacles
  module Repositories
    ##
    # Github Authentication repository
    #
    class Authentication
      def authenticate_with_code(code)
        authentication.authenticate_with_code(code)
      end

      private

      def authentication
        @authentication ||= Tentacles::Datasources::Github::Authentication.new
      end
    end
  end
end
