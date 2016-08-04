
Bundler.setup(:default)
$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/app")

require 'dotenv'
Dotenv.load

require 'app'
run Tentacles::Application
