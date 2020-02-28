# frozen_string_literal: true

require 'arssene/version'
require 'arssene/lib/rss'
require 'rss'
require 'open-uri'
require 'sanitize'
require 'mechanize'
require 'byebug'

require 'arssene/lib/interactions/feed_interaction'
require 'arssene/lib/repositories/feed_repository'
module Arssene
  class Error < StandardError; end
  # Your code goes here...
end
