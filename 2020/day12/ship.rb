# frozen_string_literal: true

require_relative 'cardinal_vectors'

class Ship
  attr_accessor :direction, :coordinates, :waypoint

  def initialize(direction = 'E', origin: [0, 0])
    @direction = direction
    @coordinates = origin.clone
  end

  def move(spaces, in_direction: nil)
    vector = CARDINAL_VECTORS[in_direction || direction]
    self.coordinates = [coordinates[0] + (vector[0] * spaces),
                        coordinates[1] + (vector[1] * spaces)]
  end

  def turn(degrees)
    keys = CARDINAL_VECTORS.keys
    new_key = (keys.index(direction) + (degrees / 90)) % keys.length
    self.direction = keys[new_key]
  end

  def move_towards_waypoint(spaces)
    vector = [waypoint.coordinates[0] * spaces, waypoint.coordinates[1] * spaces]
    self.coordinates = [coordinates[0] + vector[0],
                        coordinates[1] + vector[1]]
  end
end
