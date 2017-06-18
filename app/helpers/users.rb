require './app/repositories/user'

module Helpers
  ##
  # Users helper
  #
  module Users
    def access_token
      session[:access_token] || nil
    end

    def current_user
      users.find_by_access_token(access_token)
    end

    def logout
      session[:access_token] = nil
      session.clear
      redirect '/'
    end

    def users
      @users ||= Repositories::User.new
    end
  end
end
