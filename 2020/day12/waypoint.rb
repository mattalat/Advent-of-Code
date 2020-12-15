# frozen_string_literal: true

require_relative 'cardinal_vectors'

class Waypoint
  attr_accessor :coordinates

  def initialize(coordinates = [0, 0])
    @coordinates = coordinates
  end

  def move(spaces, in_direction:)
    vector = CARDINAL_VECTORS[in_direction || direction]
    self.coordinates = [coordinates[0] + (vector[0] * spaces),
                        coordinates[1] + (vector[1] * spaces)]
  end

  def rotate(degrees)
    new_heading = heading + (2 * Math::PI * (degrees / 360.0))
    self.coordinates = [(Math.cos(new_heading) * magnitude).round,
                        (Math.sin(new_heading) * magnitude).round]
  end

  private

  def heading
    scalar = Math.asin(coordinates[1].to_f / magnitude) >= 0 ? 1 : -1
    Math.acos(coordinates[0].to_f / magnitude) * scalar
  end

  def magnitude
    Math.sqrt(coordinates[0]**2 + coordinates[1]**2)
  end
end
