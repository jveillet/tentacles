require 'octokit'

module Tentacles
  module Helpers
    ##
    # Github client helper
    module Client
      def client
        @client ||= Octokit::Client.new(:access_token => session[:access_token])
      end
    end
  end
end
