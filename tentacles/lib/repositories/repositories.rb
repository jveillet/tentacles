require 'datasources/github'
require 'utils/cache'

module Repositories
  ##
  # Github repository
  #
  class Repositories
    include Utils::Cache
    DEFAULT_VISIBILITY = 'all'.freeze

    def find_repositories_by_user(user, visibility_filter: DEFAULT_VISIBILITY,
                                  access_token:)
      key = cache_key('repositories_by_user', user.login, visibility_filter)
      load_from_cache(key) do
        repositories.find_repositories(
          visibility_filter,
          access_token: access_token
        )
      end
    end

    private

    def repositories
      @repositories ||= Datasources::Github::Repositories.new
    end
  end
end
