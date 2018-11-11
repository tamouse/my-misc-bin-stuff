#!/usr/bin/env ruby

=begin rdoc

I often download books from HumbleBundle into a single directory.
This makes the harder to import into calibre.
This tiny script will look at the files in the current direct,
create unique subdirectories from the titles, then move the books into that subdirectory.

=end

require "fileutils"

books = Dir['*']

books.each do |book|
  dir = File.basename(book, '.*')
  FileUtils.mkdir_p(dir, verbose: true)
  FileUtils.mv(book, dir, verbose: true)
end
