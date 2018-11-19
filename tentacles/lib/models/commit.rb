# frozen_string_literal: true

module Models
  ##
  # Git commit
  #
  class Commit
    attr_reader :data
    attr_accessor :similars
    attr_reader :message

    JIRA_ID_REGEXP = /\[FWS-[0-9]{1,4}\]/

    def initialize(data, message: nil)
      @data = data
      @message = message || @data.commit.message
    end

    def date
      @data.commit.author.date
    end

    def link
      @data.html_url
    end

    def jira_ids
      @message.scan(JIRA_ID_REGEXP)
    end
  end
end
