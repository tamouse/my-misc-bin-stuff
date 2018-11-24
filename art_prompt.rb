#!/usr/bin/env ruby

DATA = File.expand_path("../art_prompt_data", __FILE__)
NOUNS = File.read(File.join(DATA, "nouns.txt")).split("\n")
ADJECTIVES = File.read(File.join(DATA, "adjectives.txt")).split("\n")
VERBS = File.read(File.join(DATA, "verbings.txt")).split("\n")

puts  [ADJECTIVES.sample, NOUNS.sample, VERBS.sample].join(" / ")
