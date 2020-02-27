# frozen_string_literal: true

module Arssene
  class Feed
    def self.ping(uri)
      response = []
      begin
        if uri.is_a?(String)
          feed_uris = Feed.retrieve(uri)
          feed_uris&.each do |feed|
            link = feed.attr('href').split.join
            response.push(feed: link)
          end
        elsif uri.is_a?(Array)
          uri.each do |url|
            Thread.new do
              begin
                feed_uris = Feed.retrieve(url)
                feed_uris&.each do |feed|
                  link = feed.attr('href').split.join
                  response.push(feed: link)
                end
              rescue StandardError => e
                response.push(error: e.to_s)
              end
            end.join
          end
        else
          []
        end
        response
      rescue StandardError => e
        response.push(error: e)
      end
      response
    end

    def self.request(uri, options = {})
      response = []

      begin
        if uri.is_a?(String)
          channel = fetch(uri, options)
          if channel.is_a?(Hash) && channel.key?(:error)
            return { error: channel[:error] }
          else
            channel = filter_by_options(channel, options)
            return { feed: uri, channel: channel }
          end
        elsif uri.is_a?(Array)
          uri.each do |url|
            Thread.new do
              channel = fetch(url, options)
              if channel.is_a?(Hash) && channel.key?(:error)
                response.push(error: channel[:error])
              else
                channel = filter_by_options(channel, options)
                response.push(feed: url, channel: channel)
              end
            end.join
          end
        else
          []
        end
      rescue StandardError => e
        response.push(error: e.to_s)
      end
      response
    end

    private

    def self.fetch(uri, _options)
      begin
        channel = Channel.new
        open(uri) do |rss|
          feed = RSS::Parser.parse(rss)
          uri = URI.parse(feed.channel.link)
          channel.title = feed.channel.title
          channel.link  = feed.channel.link
          channel.host  = uri.host
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

    def self.filter_by_options(channel, options)
      if options.key?(:ignore)
        title = channel.title.downcase.split.join
        ignore = options[:ignore]
        ignore = ignore.is_a?(Array) ? (ignore = ignore.join('|')) : ignore
        rxp = /.?(#{ignore}).?/

        channel.relevant = (rxp.match(title) == false || rxp.match(title).nil?)
      end

      if options.key?(:from_date)
        unless channel.entries.empty?
          index = channel.entries.index { |entry| entry.publication_date == options[:from_date] }
          channel.entries = index ? channel.entries.slice(0..index) : channel.entries
        end
      end

      if options.key?(:limit)
        limit = (options[:limit] - 1)
        channel.entries = channel.entries.slice(0..limit) if channel.entries.length > limit
      end
      channel
    end

    def self.retrieve(uri)
      agent = Mechanize.new
      uri   = URI.parse(uri)
      site  = agent.get(uri)
      site.search(".//link[@type='application/rss+xml']")
    end

    def self.extract_items(feed)
      entries_presenter = Arssene::EntryPresenter.new
      entries_presenter.as_entries(handler: Entry.new, items: feed.items)
    end
  end
end
