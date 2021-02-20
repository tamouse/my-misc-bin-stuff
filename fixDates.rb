#!/usr/bin/env ruby
# frozen_string_literal: true

# convert folder/file names using Mmm dd, YYYY to YYYY-MM-DD format
#
# - recognize and extract dates in Mmm dd, YYYY format from a longer string (date embedded)
# - retain non-date part and append to the converted YYYY-MM-DD date, strip trailing spaces
#   and punctuation

require "date"
require "pathname"
require "time"

MONTH_NAMES = %w[
  January
  February
  March
  April
  May
  June
  July
  August
  September
  October
  November
  December
].freeze

MONTH_NAME_TO_NUMBER = MONTH_NAMES.map.with_index { |name, idx| [name, idx + 1] }.to_h.freeze

def path_to_date(path)
  month_name, day, year = path.to_s.split[-3..-1]
  return unless MONTH_NAMES.include?(month_name)

  month = MONTH_NAME_TO_NUMBER[month_name]
  return unless month

  Date.new(year.to_i, month, day.to_i).iso8601 rescue nil
end

def new_path(path, isodate)
  new_path = path.to_s.split[0..-4]
  new_path.unshift("-") unless new_path.empty?
  new_path.unshift(isodate)

  Pathname.new(new_path.join(" ").sub(/,$/, ''))
end

def rename_path(path, new_path)
  path.rename(new_path)
rescue => exception
  warn "#{exception.class}: #{exception}"
end

def fix_dates_in_dir(dir = '.')
  kids = Pathname(dir).children
  kids.each do |kid|
    isodate = path_to_date(kid)
    next unless isodate

    new_kid = new_path(kid, path_to_date(kid))
    next if new_kid == kid

    print "Converting #{kid} to #{new_kid} (Y/n)? "
    next if gets.chomp.downcase =~ /^n/

    rename_path(kid, new_kid)
  end
end

fix_dates_in_dir
