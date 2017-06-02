require 'sinatra/base'
require 'tentacles/controllers/base'
require 'tentacles/helpers/users'
require 'tentacles/repositories/repositories'

module Tentacles
  module Controllers
    ##
    # Class Repositories
    #
    class Repositories < Base
      helpers Helpers::Users
      helpers do
        def repositories
          @repositories ||=
            Tentacles::Repositories::Repositories.new(access_token)
        end

        def visibility(params)
          return 'all' unless params
          result = if %w[public private].include? params[:visibility]
                     params[:visibility]
                   else
                     'all'
                   end
          result
        end
      end

      before do
        logout unless current_user
      end

      get '/' do
        display_filter = visibility(params)

        repos = repositories.find_repositories(
          visibility_filter: display_filter
        )
        erb :repositories, :locals => { :user => current_user, :repos => repos }
      end
    end
  end
end
