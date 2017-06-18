require './app/datasources/github/authentication'

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
      @authentication ||= Datasources::Github::Authentication.new
    end
  end
end
