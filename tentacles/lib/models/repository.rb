module Models
  # Represent a code repository
  class Repository
    attr_reader :key
    attr_reader :pull_requests

    def initialize(repo_key, pull_requests)
      @key = repo_key
      @pull_requests = pull_requests || []
      @pull_requests.sort! { |pr_a, pr_b|
          pr_b.age <=> pr_a.age }
    end

    def pull_requests_count
      @pull_requests.size
    end

    def name
      @key.split('/')[1]
    end
  end
end
