# frozen_string_literal: true

require_relative '../advent'
require_relative 'ticket'
require 'byebug'

raw = Advent.read.map(&:chomp)

rules = raw.take_while { _1 !~ /(^your ticket:)/ }.reject(&:empty?)
raw = (raw - rules).grep(/\A\d/)
ticket = raw.shift
examples = raw

# Parse rules

rules_hash = {}
rules.each do |string|
  name, range_string = string.split(': ')
  ranges = range_string.split(' or ')
                       .map { _1.split('-').map(&:to_i) }
                       .map { (_1[0].._1[1]) }
  rules_hash[name] = ranges
end

my_ticket = Ticket.new(ticket, rules_hash)
examples = examples.map { Ticket.new(_1, rules_hash) }

valids = examples.select(&:valid?)
invalids = examples.reject(&:valid?)

puts "Part 1: #{invalids.map(&:invalid_numbers).flatten.sum}"

# Decode field names
# Start by using valid tickets to filter out field possibilities on each label

possible_labels = Array.new(rules_hash.length, rules_hash.keys)

valids.each do |valid_ticket|
  valid_ticket.find_potential_rules
              .each_with_index do |valid_possibilities, i|
    diff = possible_labels[i] - valid_possibilities[1]
    possible_labels[i] = possible_labels[i] - diff unless diff.empty?
  end
end

# Sort the possible locations by fewest potential rules and find final placements
# Assumes we start with a field that has only one possibility after the filtering above

unplaced_rules = possible_labels.each_with_index.sort_by { |possibilities, _| possibilities.length }
placed_rules = [unplaced_rules.shift]

until unplaced_rules.empty?
  unplaced_rules = unplaced_rules.map { |possibilities, i| [possibilities - placed_rules[0][0], i] }
  placed_rules.unshift unplaced_rules.shift
end

# Sort the final rule placements by index and remove all except the label text

final_rules = placed_rules.sort_by { |_rule, i| i }.flatten.grep(/[^\d]/)

departure_rules = final_rules.select { _1 =~ /departure/ }
product_of_departure_fields = departure_rules.map { |d| my_ticket.numbers[final_rules.index(d)] }.reduce(&:*)

puts "Part 2: #{product_of_departure_fields}"
