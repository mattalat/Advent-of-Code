# frozen_string_literal: true

require_relative '../advent'
require 'matrix'

class Simulation
  attr_accessor :active_cubes
  attr_reader :dimensions

  def initialize(seed, dimensions)
    @dimensions = dimensions
    @active_cubes = parse_initial_state(seed)
  end

  def simulate(steps)
    steps.times do
      neighbors = active_cubes.flat_map(&method(:get_neighbors))
      self.active_cubes = neighbors.tally
                                   .select { |cell, n| n == 3 || (n == 2 && active_cubes.include?(cell)) }
                                   .keys
    end
  end

  def print_active_count
    puts active_cubes.length
  end

  private

  # All direction vectors in this simulation's dimensions
  def directions
    @directions ||= ([-1, 0, 1].repeated_permutation(dimensions).to_a - [[0] * dimensions])
  end

  # Every cell that is one unit away from the given cell in any dimension
  def get_neighbors(cell)
    directions.map { Vector[*_1] + Vector[*cell] }.map(&:to_a)
  end

  # Extract active cubes form seed array. Seed array is expected to be 2 dimensional.
  def parse_initial_state(seed)
    w = seed.length

    w.times.flat_map do |x|
      w.times.collect do |y|
        [x, y].fill(0, 2...dimensions) if seed[x][y] == '#'
      end.compact
    end
  end
end

seed = Advent.read.map { _1.split('') }

(3..4).each do |dimensions|
  Simulation.new(seed, dimensions)
            .tap { _1.simulate(6) }
            .then(&:print_active_count)
end
