#!/usr/bin/env ruby

# Convert images by putting them into a subdirectory, such making a collection of
# thumbnails for a gallery.

require "optparse"
require "awesome_print"
require "fileutils"

@options = {
  format: 'jpg',
  geom: nil,
  gravity: 'center',
  quality: 60,
  size: 200,
  thumb: false,
  verbose: false,
}

def putsverbose(*args)
  puts(*args) if @options[:verbose]
end

def apverbose(*args)
  ap(*args) if @options[:verbose]
end

OptionParser.new do |opts|
  opts.banner = 'Usage: convert_images.rb [options] SUBDIR FILES...'

  opts.on('-h', '--help', 'Print this help') do
    puts opts
    exit
  end

  opts.on('-v', '--[no-]verbose', "Run verbosely (#{@options[:verbose]})") { |v| @options[:verbose] = v }
  opts.on('-ZSIZE', '--size=SIZE', "Size to resize to (#{@options[:size]})") { |v| @options[:size] = v }
  opts.on('-qQUALITY', '--quality=QUALITY', "Quality of output (#{@options[:quality]})") { |v| @options[:quality] = v }
  opts.on('-fFORMAT', '--format=FORMAT', "Format of output files (#{@options[:format]})") { |v| @options[:format] = v }
  opts.on('-t', '--[no-]thumb', "Create square thumbnail (#{@options[:thumb]})") { |v| @options[:thumb] = v }
  opts.on('-GGRAVITY', '--gravity=GRAVITY', "Gravity for cropping thumnails (#{@options[:gravity]})") { |v| @options[:gravity] = v }
  opts.on('-gGEOM', '--geometry=GEOM', "Geometry / extent of thumbnail image (WxH)") { |v| @options[:geom] = v }
end.parse!

subdir = ARGV.shift
unless subdir
  STDERR.puts 'ERROR: Subdirectory must be provided'
  exit(-1)
end

files = ARGV
if files.empty?
  STDERR.puts 'ERROR: Must specify 1 or more files'
  exit(-1)
end

putsverbose 'Options:'
apverbose @options
putsverbose 'Subdir'
apverbose subdir
putsverbose 'Files'
apverbose files


putsverbose

FileUtils.mkdir_p subdir

cmd_opts = []

cmd_opts.push('-verbose') if @options[:verbose]
cmd_opts.push("-format #{@options[:format]}")
cmd_opts.push("-path #{subdir}")
if @options[:thumb]
  @options[:geom] = "#{@options[:size]}x#{@options[:size]}" if @options[:geom].nil?
  cmd_opts.push("-thumbnail #{@options[:geom]}^")
  cmd_opts.push("-gravity #{@options[:gravity]}")
  cmd_opts.push("-extent #{@options[:geom]}")
else
  cmd_opts.push("-resize #{@options[:size]}")
  cmd_opts.push("-quality #{@options[:quality]}")
end
files.each { |f| cmd_opts.push(f) }

putsverbose 'Mogrify options:'
apverbose cmd_opts

cmd = "mogrify #{cmd_opts.join(' ')}"
putsverbose 'Mogrify command:'
apverbose cmd

system(cmd)
