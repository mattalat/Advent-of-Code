# frozen_string_literal: true

# Load input
input = File.read(File.expand_path('input.txt', __dir__))
lines = input.split("\n").push('') # add empty terminator as coda

# Groupify
groups = []
group_string = ''
lines.each do |line|
  if line.empty?
    groups << group_string
    group_string = ''
  else
    group_string += line + ' '
  end
end

# Yes answers per group
yes_counts = groups.compact.map do |group|
  group.chars.select { |c| c =~ /[A-z]/ }.map(&:downcase).uniq.count
end

puts yes_counts.sum
