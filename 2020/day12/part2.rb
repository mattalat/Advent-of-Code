# frozen_string_literal: true

require_relative '../advent'
require_relative 'ship'
require_relative 'waypoint'
require_relative 'cardinal_vectors'

instructions = Advent.load_input_into_array

ship = Ship.new
waypoint = Waypoint.new [10, 1]
ship.waypoint = waypoint

instructions.each do |instruction|
  direction = instruction[0]
  amt = instruction[1..].to_i

  if CARDINAL_VECTORS.include? direction
    waypoint.move amt, in_direction: direction
  elsif direction == 'F'
    ship.move_towards_waypoint amt
  elsif direction == 'B'
    ship.move_towards_waypoint(-1 * amt)
  else
    scalar = direction == 'R' ? -1 : 1
    waypoint.rotate(amt * scalar)
  end
end

puts ship.coordinates[0].abs + ship.coordinates[1].abs
