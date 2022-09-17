# frozen_string_literal: true

require 'arssene/version'
require 'rss'
require 'faraday'
require 'mechanize'
require 'parallel'
require 'sanitize'

require 'arssene/lib/models/channel'
require 'arssene/lib/models/entry'
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
