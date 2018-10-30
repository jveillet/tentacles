require 'date'

module Models
  # Represent a code repository
  class PullRequest
    attr_reader :number
    attr_reader :title
    attr_reader :author_name
    attr_reader :author_thumbnail
    attr_reader :last_updated_date
    attr_reader :tags
    attr_reader :mergeable
    attr_reader :code_additions
    attr_reader :code_deletions
    attr_reader :repo_id
    attr_reader :repo_name

    def initialize(data)
      @number = data[:number]
      @title = data[:title]
      @author_name = data[:author_name]
      @author_thumbnail = data[:author_thumbnail]
      @last_updated_date = data[:last_updated_date]
      @tags = data[:tags]
      @mergeable = data[:mergeable]
      @code_additions = data[:code_additions]
      @code_deletions = data[:code_deletions]
      @repo_id = data[:repo_id]
      @repo_name = data[:repo_name]
    end

    def shorten_title
      @title unless @title.size > 30
      "#{@title[0, 30]}..."
    end

    def age
      (Date.today.to_date - @last_updated_date.to_date).to_i
    end

    def seniority
      return 'big-bang' if age > 100
      return 'dynosaur' if age > 30
      return 'old' if age > 5
      'young'
    end
  end
end
