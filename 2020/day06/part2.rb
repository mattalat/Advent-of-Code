# frozen_string_literal: true

# Load input
input = File.read(File.expand_path('input.txt', __dir__))
lines = input.split("\n").push('') # add empty terminator as coda

# Groupify
groups = []
group = []
lines.each do |line|
  if line.empty?
    groups << group
    group = []
  else
    group << line
  end
end

# Yes answers per group
all_yes_counts = groups.compact.map do |g|
  # Sanitize and get answer sets for each individual
  people = []
  g.each { |person| people << person.chars.select { |c| c =~ /[A-z]/ }.map(&:downcase).uniq }

  # Find intersection of all answer sets in group
  people.reduce(:&).count
end

puts all_yes_counts.sum
