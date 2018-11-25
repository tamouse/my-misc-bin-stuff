#!/usr/bin/env ruby

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
