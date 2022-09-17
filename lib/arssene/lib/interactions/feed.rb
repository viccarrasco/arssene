# frozen_string_literal: true

module Arssene
  class Feed
    def self.ping(urls)
      Arssene::Ping.new
                   .request(urls)
    end

    def self.request(urls, **filters)
      Arssene::Fetch.new
                    .request(urls, **filters)
    end
  end
end
