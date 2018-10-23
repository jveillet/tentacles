# frozen_string_literal: true

require 'sinatra/base'
require 'repositories/user'
require_relative 'application_controller'
require 'dotenv'
require 'octokit'

module Controllers
  ##
  # Authentication controller
  # Handles the callback response from Github
  # see Github documentation:
  # https://developer.github.com/apps/building-integrations/setting-up-and-registering-oauth-apps/about-authorization-options-for-oauth-apps/
  #
  class AuthenticationController < ApplicationController
    helpers do
      def users
        @users ||= Repositories::User.new
      end
    end
    get '/authentication/callback' do
      session_code = (request.env['rack.request.query_hash'] || {})['code']
      error!('Unauthorized', 401) unless session_code
      result = Octokit.exchange_code_for_token(session_code, ENV['GH_CLIENT_ID'], ENV['GH_CLIENT_SECRET'])

      session[:access_token] = result[:access_token]

      redirect '/repositories'
    end
  end
end
