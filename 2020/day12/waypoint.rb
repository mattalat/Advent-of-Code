# frozen_string_literal: true

require_relative 'cardinal_vectors'
require 'matrix'

class Waypoint
  attr_accessor :coordinates

  def initialize(coordinates = Vector[0, 0])
    @coordinates = coordinates.clone
  end

  def move(spaces, in_direction:)
    vector = CARDINAL_VECTORS[in_direction || direction]
    self.coordinates += vector * spaces
  end

  def rotate(degrees)
    new_heading = heading + Math::PI * (degrees / 180.0)
    self.coordinates = Vector[Math.cos(new_heading), Math.sin(new_heading)] * coordinates.magnitude
    self.coordinates = self.coordinates.round
  end

  private

  def heading
    Math.atan2 coordinates[1], coordinates[0]
  end
end
