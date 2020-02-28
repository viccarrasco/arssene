# frozen_string_literal: true

module Arssene
  class FeedInteraction
    def initialize
      @feed_repository = Arssene::FeedRepository.new
    end

    def ping(uris)
      feed_repository.ping(uris: uris)
    end

    def request
    end

    private

    attr_reader :feed_repository
  end
end
