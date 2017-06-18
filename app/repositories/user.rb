require './app/datasources/github/user'

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
      @users ||= Datasources::Github::User.new
    end
  end
end
