# frozen_string_literal: true

module Arssene
  class Fetch
    def initialize
      @channel_repository = Arssene::ChannelRepository.new
    end

    def request(urls:, **filters)
      if urls.is_a?(String)
        fetch_channel(urls, filters)
      elsif urls.is_a?(Array)
        urls.map { |url| fetch_channel(url, filters) }
      end
    end

    private

    def fetch_channel(urls, **filters)
      feed = channel_repository
             .fetch_as_channel(urls)

      Arssene::ChannelPresenter.new(feed).filter(filters)
    end

    attr_reader :channel_repository
  end
end
