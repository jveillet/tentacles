require './app/helpers/users'
require './app/repositories/repositories'
require_relative 'application_controller'

module Controllers
  ##
  # Class Repositories
  #
  class RepositoriesController < ApplicationController
    helpers Helpers::Users
    helpers do
      def repositories
        @repositories ||= Repositories::Repositories.new
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

    get '/repositories' do
      display_filter = visibility(params)

      repos = repositories.find_repositories_by_user(
        current_user,
        visibility_filter: display_filter,
        access_token: access_token
      )

      erb :repositories, :locals => { :user => current_user, :repos => repos }
    end
  end
end
