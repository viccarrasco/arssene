# frozen_string_literal: true

module Arssene
  class EntryPresenter
    def as_entries(handler:, items:)
      items.map do |item|
        entry = handler.new
        entry.title = item.title
        entry.link  = item.link || item&.enclosure&.url
        entry.description = item.description
        entry.publication_date = item.pubDate
        entry.author  = item.author
        entry.content = generate_content(item)
        entry
      end
    end

    private

    def generate_content(item)
      if item.respond_to?('content')
        item.content
      elsif item.respond_to?('content_encoded')
        item.content_encoded
      else
        entry.description
      end
    end
  end
end
