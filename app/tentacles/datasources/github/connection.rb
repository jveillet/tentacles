require 'octokit'

module Tentacles
  module Datasources
    module Github
      ##
      # Github connection
      #
      module Connection
        def client(access_token)
          connect(access_token)
        end

        private

        def connect(access_token)
          Octokit.auto_paginate = true
          @connect ||= Octokit::Client.new(
            :access_token => access_token
          )
        end
      end
    end
  end
end
