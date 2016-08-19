module Tentacles
  module Helpers
    ##
    # Authentication helper
    module Authentication
      def authenticated?
        session && session[:access_token]
      end
      def logout
        session[:access_token] = nil
        session.clear
        redirect '/'
      end
    end
  end
end
