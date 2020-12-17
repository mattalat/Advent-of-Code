# frozen_string_literal: true

require 'matrix'

CARDINAL_VECTORS = {
  'N' => Vector[0, 1],
  'E' => Vector[1, 0],
  'S' => Vector[0, -1],
  'W' => Vector[-1, 0]
}.freeze
