# frozen_string_literal: true

require 'arssene/version'
require 'arssene/lib/rss'
require 'rss'
require 'open-uri'
require 'sanitize'
require 'mechanize'
require 'byebug'

require 'arssene/lib/models/channel.rb'
require 'arssene/lib/models/entry.rb'
require 'arssene/lib/interactions/feed'
require 'arssene/lib/interactions/ping'
require 'arssene/lib/interactions/fetch'
require 'arssene/lib/repositories/feed_repository'
require 'arssene/lib/repositories/channel_repository'
require 'arssene/lib/presenters/entry_presenter'
require 'arssene/lib/presenters/channel_presenter'
module Arssene
  class Error < StandardError; end
  # Your code goes here...
end
