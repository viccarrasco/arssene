# frozen_string_literal: true

module Arssene
  class Ping
    def request(urls:)
      if urls.is_a?(String)
        retrieve_feed_urls(urls)
      elsif urls.is_a?(Array)
        urls.map { |url| retrieve_feed_urls(url).first }
      end
    end

    private

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

    def embeded_html_source_links(url)
      agent = Mechanize.new
      url = URI.parse(url)
      site = agent.get(url)
      site.search(".//link[@type='application/rss+xml']")
    end
  end
end
