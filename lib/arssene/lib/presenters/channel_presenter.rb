# frozen_string_literal: true

module Arssene
  class ChannelPresenter
    def filter(channel:, options: {})
      return channel unless options.keys.any?

      if options.key?(:ignore)
        title = channel.title.downcase.split.join
        ignore = options.fetch(:ignore)
        ignore = ignore.is_a?(Array) ? ignore.join('|') : ignore
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
  end
end
