# frozen_string_literal: true

module Arssene
  class Channel
    attr_accessor :title, :link, :host, :feed_type, :feed_version, :description, :publication_date, :language,
                  :copyright, :entries, :meta, :relevant, :rss_link
  end
end
