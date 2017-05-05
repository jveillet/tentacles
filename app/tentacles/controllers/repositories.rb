require 'sinatra/base'
require 'tentacles/controllers/base'
require 'tentacles/helpers/authentication'
require 'tentacles/helpers/client'

module Tentacles
  module Controllers
    ##
    # Class Repositories
    #
    class Repositories < Base
      helpers Helpers::Authentication
      helpers Helpers::Client

      before do
        logout unless authenticated?
      end

      get '/' do
        display_filter = visibility(params)

        repositories = client.repositories(nil, :visibility => display_filter)
        user = client.user
        erb :repositories, :locals => { :user => user, :repos => repositories }
      end

      def visibility(params)
        return 'all' unless params
        result = if %w(public private).include? params['visibility']
                   params['visibility']
                 else
                   'all'
                 end
        result
      end
    end
  end
end
