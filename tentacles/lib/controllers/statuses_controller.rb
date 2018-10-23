# frozen_string_literal: true

require 'sinatra/base'
require 'repositories/statuses'
require_relative 'application_controller'
require 'sinatra/json'
require 'helpers/users'

module Controllers
  ##
  # Commit Statuses controller
  #
  class StatusesController < ApplicationController
    helpers Helpers::Users
    helpers do
      def statuses
        @statuses ||= Repositories::Statuses.new
      end
      def users
        @users ||= Repositories::User.new
      end
    end

    before do
      halt 403 unless current_user
    end

    get '/statuses' do
      options = { access_token: session[:access_token] }
      sha = params['sha']
      repo = params['repo']
      response = statuses.check_status(repo, sha, options)
      state = response&.first.nil? ? "Unknown" : response.first[:state]
      json :state => state, :sha => sha
    end
  end
end
