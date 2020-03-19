#!/usr/bin/env ruby
#
# Write a yaml file suitable for a jekyll front matter section showing
# how to get to the image files created by makegallery.rb
#
# basic template:
#
# gallery:
#   path: path/to/images/on/s3/
#   images:
#     - fullsize: image.jpg
#       gallery: gallery/image.jpg
#       web: webs/image.jpg
#       thumb: thumbs/image.gif
#       caption: "some words"
#       description: |-
#         A long description for the image.
#
#         This will get run through markdownify.
#
#         Yay.
#
# WHY DID I WRITE THIS?
#
# it was at one point to make my life easier when i was creating an art blog using
# jekyllrb. Turns out that's really too much work after all. But this still
# exists. There's a lot of overlap between this and the ./convert_images.rb script,
# too. (like a *lot*).

require 'yaml'
require 'pathname'

def get_path(dir='.')
  full_path = Pathname.new(dir).expand_path().to_s
  remove_path = Pathname(ENV["HOME"]).join("Art").to_s + ?/
  (full_path.sub(/#{remove_path}/, '') + ?/).tap{|t| STDERR.puts "get_path returns:", t.inspect}
end


gallery = {
  "gallery" => {
      "path" => get_path
  }
}

image_entry = {
  "fullsize" => "",
  "gallery" => "",
  "web" => "",
  "thumb" => "",
  "caption" => "",
  "description" => "blah blah"
}

images = [];

# acquire the image files
filelist = Dir['*'].select{|f| f =~ /\.(jpe?g|png|gif)/}

images = filelist.map do |f|
  {
    "fullsize" => "#{f}",
    "gallery"  => "gallery/#{f}",
    "web"      => "webs/#{f}",
    "thumb"    => "thumbs/#{File.basename(f, '.*')}.gif",
    "caption"  => f.to_s,
    "description" => "\n\n"
  }
end

gallery["gallery"]["images"] = images

gallery_yaml = gallery.to_yaml.gsub(/\|2\+/,'|-')
File.write('gallery.yml',gallery_yaml)
