#!/usr/bin/env ruby

require 'csv'
require 'time'
require "pry"

csv_table = File.open(ARGV.first) do |incsv|
  CSV.table incsv
end
$stderr.puts csv_table

new_table = CSV::Table.new([], headers: %w[Date Systolic Diastolic BPM])
csv_table.each { |row|
  $stderr.puts row
  d, bpdata, _w, _n = row.fields

  date = Time.parse(d, "%B %e, %Y %I:%M %p")

  bp, bpm = bpdata.split(", ")
  systolic, diastolic = bp.split("/")
  bpm = bpm.split(" ").first
  $stderr.puts date, systolic, diastolic, bpm

  new_table << [date.iso8601, systolic, diastolic, bpm]
}

puts new_table
