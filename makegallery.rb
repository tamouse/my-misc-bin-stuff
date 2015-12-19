#!/usr/bin/env ruby
#
# Make a collection of gallery images:
# - thumbnails: 200x200 square
# - gallery: 450 horizontal
# - web: 1024 horizontal

require 'fileutils'
require 'yaml'
require 'pathname'

DEFAULTS = {
  thumbs: { dir: 'thumbs', geom: '200x200', format: 'gif', quality: 40, options: '-thumbnail %{geom}^ -gravity center -extent %{geom}' },
  gallery: { dir: 'gallery', geom: '450', format: 'jpg', quality: 60, options: '-resize %{geom} -quality %{quality}' },
  web: { dir: 'webs', geom: '1024', format: 'jpg', quality: 75, options: '-resize %{geom} -quality %{quality}' }
}

def imagefiles(start=Dir.pwd)
  @imagefiles ||= Dir[File.join(start),'*'].select{|f| f =~ /\.(jpe?g|png|gif)$/ }
end

def yamlfile(start=Dir.pwd)
  Pathname.new(start).split.last.to_s + '.yml'
end

def process(dir, geom, format, quality, options, start='.')
  options = options % {
    geom: geom,
    quality: quality
  }
  Dir.chdir(start) do |root|
    FileUtils.mkdir_p(dir)
    cmd = %Q{mogrify -verbose -path #{dir} -format #{format} #{options} #{imagefiles.join(" ")}}
    `#{cmd}`
  end
end

def get_image_path(dir=Dir.pwd)
  Pathname.new(dir).expand_path().to_s.split("/").drop(4).join("/") + ?/
end

def yamlize(galleries=DEFAULTS, start=Dir.pwd)
  {
    "gallery" => {
      "path" => get_image_path(start),
      "images" => imagefiles.map do |f|
        fb = File.basename(f, '.*')
        {
          "fullsize" => f,
          "gallery" => "gallery/#{fb}.#{galleries[:gallery][:format]}",
          "web" => "webs/#{fb}.#{galleries[:web][:format]}",
          "thumb" => "thumbs/#{fb}.#{galleries[:thumbs][:format]}",
          "caption" => "#{fb.split(/[-_]/).map(&:capitalize).join(" ")}",
          "description" => "\ndescription\n\n"
        }
      end
    }
  }.to_yaml
end

def main(galleries=DEFAULTS, start=Dir.pwd)
  puts "\nProcessing directory #{start}\n"
  galleries.each do |type, options|
    puts "Making #{type}"
    process(options[:dir], options[:geom], options[:format], options[:quality], options[:options], start)
    puts "done\n"
  end
  puts "\nCreating yaml entry"
  File.write(yamlfile, yamlize)
end

main()
