# Matt Pruitt
# Ruby Library for working with Vimeo

require 'rubygems'
require 'digest/md5'
require 'open-uri'
require 'hpricot'

require File.expand_path(File.join(File.dirname(__FILE__), %w[lib rbVimeo]))
require File.expand_path(File.join(File.dirname(__FILE__), %w[lib Video]))
require File.expand_path(File.join(File.dirname(__FILE__), %w[lib Thumbnail]))
require File.expand_path(File.join(File.dirname(__FILE__), %w[lib User]))
require File.expand_path(File.join(File.dirname(__FILE__), %w[lib Comment]))