#!/usr/bin/env ruby

# Stupid ruby tricks, converting between yaml and json, really not that interesting

require "yaml"
require "json"
require "pathname"

ARGV.each do |arg|
  path = Pathname.new(arg)
  if path.extname.match(/ya?ml/)
    newpath = path.sub(/ya?ml$/, "json")
    File.write(newpath, JSON.pretty_generate(YAML.load_file(path)))
  else
    STDERR.puts "Skipping #{arg}, not a yaml file"
  end
end
