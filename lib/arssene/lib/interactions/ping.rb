# frozen_string_literal: true

module Arssene
  class Ping
    def request(urls:)
      if urls.is_a?(String)
        retrieve_feed_urls(urls)
      elsif urls.is_a?(Array)
        urls.map { |uri| retrieve_feed_urls(uri).first }
      end
    end

    private

    def retrieve_feed_urls(uri, pinged = [])
      feed_urls = embeded_html_source_links(uri)
      raise 'Non existing feeds' if feed_urls.empty?

      pinged = feed_urls.map do |feed|
        { feed: feed.attr('href').split.join }
      end
    rescue StandardError => e
      pinged.push(error: e.to_s)
    ensure
      pinged
    end

    def embeded_html_source_links(uri)
      agent = Mechanize.new
      uri = URI.parse(uri)
      site = agent.get(uri)
      site.search(".//link[@type='application/rss+xml']")
    end
  end
end
