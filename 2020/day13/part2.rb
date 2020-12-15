# frozen_string_literal: true

require_relative '../advent'

raw = Advent.load_input_into_array

busses      = raw[1].scan(/\d+/).map(&:to_i)
positions   = busses.map { |b| raw[1].split(',').index(b.to_s) }.map(&:to_i)
remainders  = busses.zip(positions).map { |bus, pos| bus - (pos % bus) }
bus_product = busses.reduce(:*)

multiples = busses.map do |bus_num|
  base = bus_product / bus_num
  multiplier = (1..).find { |n| (n * base) % bus_num == 1 }
  multiplier * base
end

puts multiples.zip(remainders).map { _1 * _2 }.sum % bus_product
