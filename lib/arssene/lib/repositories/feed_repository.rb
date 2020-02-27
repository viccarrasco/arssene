# frozen_string_literal: true

module Arssene
  class FeedRepository
    def initialize(agent:)
      @agent = agent
    end

    def retrieve_embeded_feeds(uri)
      uri = URI.parse(uri)
      site = agent.get(uri)
      site.search(".//link[@type='application/rss+xml']")
    end

    private

    attr_reader :agent
  end
end
