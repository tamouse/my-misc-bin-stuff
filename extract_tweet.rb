#!/usr/bin/env ruby
#
# pulls a twitter thread using the URL of the staring tweet, removing all formatting, leaving just the text from the page.
#
# You (ie. me) wrote this so you could copy tweet threads into notes and hang on to them forever and ever

require 'curb'
require 'nokogiri'
require 'pry'

def extract(url)
  http = Curl::Easy.perform(url)
  html = http.body_str
  doc = Nokogiri::HTML.parse(html)
  binding.pry
  doc.css('article[role=article]').text
end

ARGV.each do |arg|
  puts extract(arg)
end
