# frozen_string_literal: true

require 'helpers/users'
require 'helpers/repositories'
require 'repositories/repositories'
require 'repositories/issues'
require_relative 'application_controller'

module Controllers
  ##
  # Class Repositories
  #
  class RepositoriesController < ApplicationController
    helpers Helpers::Users
    helpers Helpers::Repositories
    helpers do
      def users
        @users ||= Repositories::User.new
      end

      def repositories
        @repositories ||= Repositories::Repositories.new
      end

      def github_issues
        @github_issues ||= Repositories::Issues.new
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

      erb :repositories, locals: {
        user: current_user,
        repos: repos,
        selected_repos: selected_repos
      }, layout: :tentacles_layout
    end

    post '/repositories/selection' do
      cookies[:repos] = params[:repos]
      redirect to(params[:redirect])
    end
  end
end
