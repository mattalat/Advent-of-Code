# frozen_string_literal: true

require_relative 'cardinal_vectors'
require 'matrix'

class Ship
  attr_accessor :direction, :coordinates, :waypoint

  def initialize(direction = 'E', origin: Vector[0, 0])
    @direction = direction
    @coordinates = origin.clone
  end

  def move(spaces, in_direction: nil)
    vector = CARDINAL_VECTORS[in_direction || direction]
    self.coordinates += vector * spaces
  end

  def turn(degrees)
    keys = CARDINAL_VECTORS.keys
    new_key = (keys.index(direction) + (degrees / 90)) % keys.length
    self.direction = keys[new_key]
  end

  def move_towards_waypoint(spaces)
    self.coordinates += waypoint.coordinates * spaces
  end
end
