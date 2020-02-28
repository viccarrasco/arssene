# frozen_string_literal: true

module Arssene
  class FeedRepository
    def initialize
      @agent  = Mechanize.new
      @pinged = []
    end

    def ping(uris:)
      uris.is_a?(String) ? retrieve_feed_content(uris) : uris.each { |url| Thread.new { retrieve_feed_content(url, pinged: pinged) }.join }
    end

    def request(uris:)
      raise 'Not Implemented'
    end

    private

    def retrieve_feed_content(uri, pinged: [])
      begin
        feed_uris = embeded_html_source_links(uri)
        if feed_uris.empty?
          raise 'Non existing feeds'
        else
          pinged = feed_uris.map do |feed|
            { feed: feed.attr('href').split.join }
          end
        end
      rescue => e
        pinged.push(error: e.to_s)
      ensure
        pinged
      end
    end

    def embeded_html_source_links(uri)
      uri = URI.parse(uri)
      site = agent.get(uri)
      site.search(".//link[@type='application/rss+xml']")
    end

    attr_reader :agent
    attr_reader :pinged
  end
end
