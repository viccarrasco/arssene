# frozen_string_literal: true

module Arssene
  class ChannelPresenter
    attr_accessor :channel

    def initialize(channel)
      @channel = channel
    end

    def filter(options)
      return channel unless options

      filter_by_ignore(options) if options[:ignore]
      filter_by_date(options) if options[:from_date]
      limit(options) if options[:limit]

      channel
    end

    private

    def filter_by_ignore(options)
      return if channel.entries.empty?

      ignore_options = options[:ignore]

      title = channel.title.downcase.split.join

      ignored = ignore_options.is_a?(Array) ? ignore_options.join('|') : ignore_options
      rxp = /.?(#{ignored}).?/

      channel.relevant = (rxp.match(title) == false || rxp.match(title).nil?)
    end

    def filter_by_date(options)
      return if channel.entries.empty?

      from_date_option = options[:from_date]

      index = channel.entries
                     .index { |entry| entry.publication_date == from_date_option }

      channel.entries.slice!(0..index) if index
    end

    def limit(options)
      return if channel.entries.empty?

      limit_quantity = options[:limit]

      channel.entries = channel.entries.last(limit_quantity) if channel.entries.length > limit_quantity
    end
  end
end
