# frozen_string_literal: true

require_relative '../advent'

raw = Advent.load_input_into_array.map(&:to_i)

jolts = raw.uniq.sort
jolts.unshift(0).push(jolts.max + 3)

deltas = jolts.each_cons(2).map { |a, b| b - a }

puts deltas.tally[1] * deltas.tally[3]
