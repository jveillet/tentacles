# frozen_string_literal: true

module Datasources
  module Github
    ##
    # Pagination of github results
    #
    class Pagination
      attr_reader :records

      def initialize(records)
        @records = records
      end

      def next_pages(last_response)
        results = @records
        until last_response.rels[:next].nil?
          last_response = last_response.rels[:next].get
          results.concat last_response.data
        end
        results
      end
    end
  end
end
