# frozen_string_literal: true

module Arssene
  class Ping
    def initialize
      @feed_repository = Arssene::FeedRepository.new
    end

    def request(urls)
      klass = urls.class

      return retrieve_feed_urls(urls) if klass == String

      Parallel.map(urls) { |url| retrieve_feed_urls(url).first }
    end

    private

    def retrieve_feed_urls(urls)
      feed_repository.retrieve_feed_urls(urls)
    end

    attr_reader :feed_repository
  end
end
