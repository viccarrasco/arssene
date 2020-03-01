# frozen_string_literal: true

module Arssene
  class FeedRepository
    def initialize
      @agent = Mechanize.new
    end

    def ping(uris:)
      if uris.is_a?(String)
        retrieve_feed_urls(uris)
      elsif uris.is_a?(Array)
        uris.map { |uri| retrieve_feed_urls(uri).first }
      end
    end

    def request(uris:)
      if uris.is_a?(String)
      end
    end

    private

    def retrieve_feed_urls(uri, pinged = [])
      feed_uris = embeded_html_source_links(uri)
      raise 'Non existing feeds' if feed_uris.empty?

      pinged = feed_uris.map do |feed|
        { feed: feed.attr('href').split.join }
      end
    rescue StandardError => e
      pinged.push(error: e.to_s)
    ensure
      pinged
    end

    def embeded_html_source_links(uri)
      uri = URI.parse(uri)
      site = agent.get(uri)
      site.search(".//link[@type='application/rss+xml']")
    end

    attr_reader :agent
  end
end
