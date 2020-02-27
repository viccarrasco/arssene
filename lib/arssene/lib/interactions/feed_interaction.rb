# frozen_string_literal: true

module Arssene
  class FeedInteraction
    def initialize
      @feed_repository = Arssene::FeedRepository.new(agent: Mechanize.new)
    end

    def ping(uri)
      if uri.is_a?(String)

      elsif uri.is_a?(Array)
      end
    end

    def request
    end

    private

    def retrieve(uri)
      feed_uris = feed_repository.retrieve_embeded_feeds(uri)
      feed_uris.map do |feed|
        { feed: feed.attr('href').split.join }
      end
    end

    def extract_items(feed)
      entries_presenter = Arssene::EntryPresenter.new
      entries_presenter.as_entries(handler: Entry.new, items: feed.items)
    end

    attr_reader :feed_interactor
  end
end
