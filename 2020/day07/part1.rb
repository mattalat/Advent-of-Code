# frozen_string_literal: true

require_relative 'bag'

# Load input
input = File.read(File.expand_path('input.txt', __dir__))
lines = input.split("\n").map(&:strip)

# Parse input to get array of rules hashes
debagger = ->(s) { s.gsub('bags', '').gsub('bag', '').strip }
rules = {}

lines.each do |rule|
  outer, contents = rule.split(' contain ')
  contents = [contents.tr('.', '').split(', ')].flatten
  rules[debagger.call(outer)] = contents.map(&debagger)
end

# Create a Bag for each rule hash
rules.each { |name, contains| Bag.new(name, contains) }

# Do a dumb loop to find all possible ancestors
parents = Bag.parents_of('shiny gold')
new_parents = parents

until new_parents.empty?
  new_parents = new_parents.flatten.map { |b| Bag.parents_of(b.name) }
  parents << new_parents
end

puts parents.flatten.uniq.count
