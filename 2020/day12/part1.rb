# frozen_string_literal: true

require_relative '../advent'
require_relative 'ship'
require_relative 'cardinal_vectors'

instructions = Advent.load_input_into_array
ship = Ship.new

instructions.each do |instruction|
  direction = instruction[0]
  amt = instruction[1..].to_i

  if CARDINAL_VECTORS.include? direction
    ship.move amt, in_direction: direction
  elsif direction == 'F'
    ship.move amt
  elsif direction == 'B'
    ship.move(-1 * amt)
  else
    scalar = direction == 'L' ? -1 : 1
    ship.turn(amt * scalar)
  end
end

puts ship.coordinates[0].abs + ship.coordinates[1].abs
