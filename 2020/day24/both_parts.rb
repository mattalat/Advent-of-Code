# frozen_string_literal: true

require_relative '../advent'

input = Advent.read

DIRECTIONS = {
  'e' => 1 + 0i,
  'ne' => 0 + 1i,
  'nw' => -1 + 1i,
  'w' => -1 + 0i,
  'sw' => 0 - 1i,
  'se' => 1 - 1i
}.freeze

ALL_DIRECTIONS = DIRECTIONS.values.freeze

tiles = input.map(&:strip)
movements = tiles.map { |tile| tile.scan(/([ns]?[ew])/).map { DIRECTIONS[_1[0]] }.flatten }
flips = movements.map(&:sum).tally
blacks = flips.reject { (_2 % 2).zero? }

puts "Part 1: #{blacks.count}"

def neighbors(hex)
  ALL_DIRECTIONS.map { hex + _1 }
end

def play(blacks, rounds)
  (1..rounds).each do
    blacks = blacks.keys
                   .map { neighbors(_1) }
                   .flatten
                   .tally
                   .filter { |tile, n| n == 2 || (blacks.include?(tile) && n == 1) }
  end

  blacks
end

puts "Part 2: #{play(blacks, 100).count}"
