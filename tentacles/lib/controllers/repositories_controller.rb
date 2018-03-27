# frozen_string_literal: true

require 'helpers/users'
require 'repositories/repositories'
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
      puts '*****************'
      puts repos[1].to_hash[:name] # affiche le nom du repo
      puts '*****************'
      erb :repositories, locals: { user: current_user, repos: repos }
    end
=begin
    def pull_request_per_repo_count(array)
      cursor = 0
      while cursor > array.length
        yield(array[cursor])
        cursor += 1
      end
    end
    final_hash = {}

    array_given.each do |line|
      repo_name = line[:repo]

      if final_hash.key?(repo_name)
        final_hash [repo_name] += 1
      else
        final_hash [repo_name] = 1
      end
    end
=end
  end
end
