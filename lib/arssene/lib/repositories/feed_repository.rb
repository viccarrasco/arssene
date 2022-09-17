# frozen_string_literal: true

module Arssene
  class FeedRepository
    def initialize
      @agent = Mechanize.new
    end

    def retrieve_feed_urls(urls)
      pinged = []
      embeded_links = embeded_html_source_links(urls)
      raise 'Non existing feeds' if embeded_links.empty?

      pinged = embeded_links.map do |feed|
        { feed: feed.attr('href').split.join }
      end
    rescue StandardError => e
      pinged.push(error: e.to_s)
    ensure
      pinged
    end

    private

    def embeded_html_source_links(url)
      site = agent.get URI.parse(url)
      site.search(".//link[@type='application/rss+xml']")
    end

    attr_reader :agent
  end
end
