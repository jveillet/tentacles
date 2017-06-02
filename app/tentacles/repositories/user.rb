require 'tentacles/datasources/github/user'

module Tentacles
  module Repositories
    ##
    # User repository
    #
    class User
      def find_by_access_token(access_token)
        users.find_by_access_token(access_token)
      end

      def authorize_with_code(code)
        users.authorize_with_code(code)
      end

      private

      def users
        @users ||= Tentacles::Datasources::Github::User.new
      end
    end
  end
end
