# frozen_string_literal: true

class Passport
  REQ = %w[byr iyr eyr hgt hcl ecl pid].freeze

  def initialize(attr_string_array)
    @attrs = attr_string_array.map { |kv| { kv.split(':')[0] => kv.split(':')[1] } }
                              .reduce({}) { |acc, el| acc.merge(el) }
  end

  def valid?
    REQ - @attrs.keys == []
  end
end

# Load input
input = File.read(File.expand_path('input.txt', __dir__))
lines = input.split("\n").push('') # put a final empty el for coda

# Gather attribute string array and create Passports
passports = []
attribute_array = []

lines.each do |line|
  if line.empty?
    passports << Passport.new(attribute_array.flatten)
    attribute_array = []
  else
    attribute_array << line.split(' ')
  end
end

# Print count of valid Passports
puts passports.filter(&:valid?).count
