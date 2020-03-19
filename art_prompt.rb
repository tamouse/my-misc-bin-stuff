#!/usr/bin/env ruby

## Just a little ditty to pop up an art / sketch / writing prompt based on some data extracted from the unix words file into nouns, verbs and adjectives.

# SYNOPSIS
#
#     $ ~/bin/art_prompt.rb

DATA = File.expand_path("../art_prompt_data", __FILE__)
NOUNS = File.read(File.join(DATA, "nouns.txt")).split("\n")
ADJECTIVES = File.read(File.join(DATA, "adjectives.txt")).split("\n")
VERBS = File.read(File.join(DATA, "verbings.txt")).split("\n")

puts  [ADJECTIVES.sample, NOUNS.sample, VERBS.sample].join(" / ")
