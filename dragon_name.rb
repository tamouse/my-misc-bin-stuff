#!/usr/bin/env ruby

# Dragon name:
# * Last 2 letters of your first name
# * Middle 2 letters of your last name
# * First 2 letters of your mother's name
# * Last letter of your father's name

# Example:
# First Name: Tamara
# Last Name: Temple
# Mother's Name: Mary
# Father's Name: Robert or Bob
#
# My Dragon name: "Rampmat" or "Rampmab"

require 'highline'
class CLI
  attr_reader :cli
  def initialize()
    @cli = HighLine.new
  end

  def ask!
    [
      cli.ask("What is your first name?"),
      cli.ask("What is your last name?"),
      cli.ask("What is your mother's name?"),
      cli.ask("What is your father's name?")
    ]
  end
end

class DragonName

  attr_reader :first_name, :last_name, :mothers_name, :fathers_name

  def initialize(first_name, last_name, mothers_name, fathers_name)
    self.first_name = first_name
    self.last_name = last_name
    self.mothers_name = mothers_name
    self.fathers_name = fathers_name
  end

  def calculate!
    (
      last_two_of_first_name +
      middle_two_of_last_name +
      first_two_of_mothers_name +
      last_of_fathers_name
      ).
      capitalize
  end

  # Explicit setters so the input can be verified.

  def fathers_name=(s)
    check_length(__method__, s, 1)
    @fathers_name = s
  end

  def first_name=(s)
    check_length(__method__, s)
    @first_name = s
  end

  def last_name=(s)
    check_length(__method__, s)
    @last_name = s
  end

  def mothers_name=(s)
    check_length(__method__, s)
    @mothers_name = s
  end

  private

  def check_length(m, s, min_len=2)
    if s.length < min_len
      raise ArgumentError.new "#{m[0..-2]} length must be greater than or equal to #{min_len}"
    end
  end

  def first_two_of_mothers_name
    mothers_name[0..1]
  end

  def last_of_fathers_name
    fathers_name[-1]
  end

  def last_two_of_first_name
    first_name[-2..-1]
  end

  def middle_two_of_last_name
    mid = last_name.length / 2
    last_name[(mid-1)..mid]
  end
end


# MAIN

if ARGV.length < 4
  first_name, last_name, mothers_name, fathers_name = CLI.new.ask!
else
  first_name, last_name, mothers_name, fathers_name = ARGV.take(4)
end

dragon_name = DragonName.new(first_name, last_name, mothers_name, fathers_name).calculate!

puts "Your dragon name is #{dragon_name}"
