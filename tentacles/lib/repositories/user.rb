# frozen_string_literal: true

require 'datasources/github'
require 'utils/cache'

module Repositories
  ##
  # User repository
  #
  class User
    include Utils::Cache

    USERS_CACHE = 7200 # 2h

    def find_by_access_token(access_token)
      key = cache_key('user_by_access_token', access_token)
      load_from_cache(key, ttl: USERS_CACHE) do
        users.find_by_access_token(access_token)
      end
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
