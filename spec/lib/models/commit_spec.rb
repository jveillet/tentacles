require 'spec_helper'
require 'models/commit'

describe Models::Commit do
  it 'Extracts JIRA Id from commit message' do
    commit = Models::Commit.new({}, message: '[FWS-1234] asdfasf')
    commit.jira_ids.should eq(['[FWS-1234]'])
  end
end
