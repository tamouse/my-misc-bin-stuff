#!/usr/bin/env ruby
#
# pulls a twitter thread using the URL of the staring tweet, removing all formatting, leaving just the text from the page.
#
# You (ie. me) wrote this so you could copy tweet threads into notes and hang on to them forever and ever

require 'curb'
require 'nokogiri'

def extract(url)
  http = Curl::Easy.perform(url)
  html = http.body_str
  doc = Nokogiri::HTML.parse(html)
  doc.css('.js-tweet-text-container').text
end

ARGV.each do |arg|
  puts extract(arg)
end
