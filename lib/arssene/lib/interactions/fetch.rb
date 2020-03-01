# frozen_string_literal: true

module Arssene
  class Fetch
    def initialize
      @channel_repository = Arssene::ChannelRepository.new
      @channel_presenter  = Arssene::ChannelPresenter.new
    end

    def request(urls:, options: nil)
      feed = channel_repository.fetch_as_channel(feed_url: urls) if urls.is_a?(String)
      feed = channel_presenter.filter(channel: feed, options: options) unless options.nil?
      feed
    end

    private

    attr_reader :channel_repository
    attr_reader :channel_presenter
  end
end
