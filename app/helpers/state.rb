require 'digest/sha2'
require 'securerandom'

module Helpers
  ##
  # Authentication helper
  module State
    ##
    # Generate an unguessable random string.
    # It is used to protect against cross-site request forgery attacks.
    def generate_state
      Digest::SHA2.new.hexdigest(SecureRandom.uuid)
    end
  end
end
