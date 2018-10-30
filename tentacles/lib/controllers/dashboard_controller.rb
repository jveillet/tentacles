# frozen_string_literal: true

require 'helpers/users'
require 'helpers/repositories'
require 'models/repository'
require 'repositories/repositories'
require 'repositories/issues'
require_relative 'application_controller'

module Controllers
  ##
  # Class Repositories
  #
  class DashboardController < ApplicationController
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

    get '/dashboard' do
      display_filter = visibility(params)
      pull_requests_groups = []

      repos = map_repos(selected_repos!).select { |repo|
        repo.pull_requests_count > 0 }.sort { |repo_a, repo_b|
          repo_b.pull_requests_count <=> repo_a.pull_requests_count }

      erb :dashboard, locals: {
        user: current_user,
        repos: repos
      }, layout: :tentacles_layout
    end
  end
end
