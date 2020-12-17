# frozen_string_literal: true

require_relative '../advent'
require_relative 'ticket'

raw        = Advent.read.map(&:chomp)
ticket_i   = raw.index('your ticket:')
examples_i = raw.index('nearby tickets:')
rules      = raw[0...ticket_i - 1]
rules_hash = {}

rules.each do |string|
  name, range_string = string.split(': ')
  ranges = range_string.split(' or ').map { |r| r.split('-').map(&:to_i) }.map { (_1[0].._1[1]) }
  rules_hash[name] = ranges
end

ticket   = raw[ticket_i + 1...examples_i - 1].first
examples = raw[examples_i + 1..]

examples  = examples.map { Ticket.new(_1, rules_hash) }
valids    = examples.select(&:valid?)
invalids  = examples - valids

puts "Part 1: #{invalids.map(&:invalid_numbers).flatten.sum}"

my_ticket = Ticket.new(ticket, rules_hash)
all_keys = rules_hash.keys
possible_rules = Array.new(rules_hash.length, all_keys)

valids.each do |v|
  pls = v.find_potential_rules
  pls.each_with_index do |possibles, i|
    diff = possible_rules[i] - possibles[1]
    next if diff.empty?

    possible_rules[i] = possible_rules[i] - diff
  end
end

ordered = possible_rules.zip((0...possible_rules.length)).sort_by { |a, _| a.length }

ordered.each_with_index do |p, i|
  rule = p[0]
  ordered[i + 1..] = ordered[i + 1..].map { |rs, i| [rs - rule, i] }
end

departure_rules = ordered.sort_by { _2 }.map { [_1[1], _1[0].first] }.select { _1[1].match? /departure/ }
departure_fields = departure_rules.map(&:first).map(&:to_i)

puts "Part 2: #{departure_fields.map { my_ticket.numbers[_1] }.reduce(&:*)}"
