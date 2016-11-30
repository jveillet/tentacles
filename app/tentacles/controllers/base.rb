require 'sinatra/base'

module Tentacles
  module Controllers
    ##
    #
    class Base < Sinatra::Base
      configure do
        set :root, './app/tentacles'
        set :sessions, false
        set :show_exceptions, true
      end

      error Sinatra::NotFound do
        #haml :not_found, layout: false
      end
    end
  end
end
