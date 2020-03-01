# frozen_string_literal: true

module Arssene
  class Feed
    def self.ping(urls:)
      ping = Arssene::Ping.new
      ping.request(urls: urls)
    end

    def self.request(urls:, options:)
      fetch = Arssene::Fetch.new
      fetch.request(urls: urls, options: options)
    end
  end
end
