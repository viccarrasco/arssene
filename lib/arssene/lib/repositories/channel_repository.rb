# frozen_string_literal: true

module Arssene
  class ChannelRepository
    def fetch_as_channel(url)
      begin
        channel = Arssene::Channel.new
        open(url) do |rss|
          feed = RSS::Parser.parse(rss)
          url = URI.parse(feed.channel.link)
          channel.title = feed.channel.title
          channel.link  = feed.channel.link
          channel.host  = url.host
          channel.feed_type = feed.feed_type
          channel.feed_version = feed.feed_version
          channel.description = feed.channel.description
          channel.publication_date = feed.channel.pubDate
          channel.language = feed.channel.language ? feed.channel.language.downcase : nil
          channel.copyright = feed.channel.copyright
          channel.entries = extract_items feed
          channel.meta = feed
          channel.relevant = true
        end
      rescue StandardError => e
        return ({ error: e.to_s })
      end
      channel
    end

    private

    def extract_items(feed)
      entries_presenter = Arssene::EntryPresenter.new
      entries_presenter.as_entries(handler: Entry.new, items: feed.items)
    end
  end
end