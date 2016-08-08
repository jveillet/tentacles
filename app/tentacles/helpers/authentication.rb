module Tentacles
  module Helpers
    ##
    # Authentication helper
    module Authentication
      def authenticated?
        session && session[:access_token]
      end
    end
  end
end
