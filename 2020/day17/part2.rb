# frozen_string_literal: true

require_relative '../advent'
require 'matrix'

t0 = Advent.read.map { _1.split('') }
w = t0.length / 2

DIRECTIONS = ([-1, 0, 1].repeated_permutation(4).to_a - [[0, 0, 0, 0]]).freeze

def get_neighbors(cell)
  DIRECTIONS.map { Vector[*_1] + Vector[*cell] }.map(&:to_a)
end

# Get initial active cells

active_cubes = []

t0.length.times do |x|
  t0.length.times do |y|
    active_cubes << [x - w, y - w, 0, 0] if t0[x][y] == '#'
  end
end

6.times do
  neighbors = active_cubes.map { get_neighbors _1 }.flatten(1).tally
  active_cubes = neighbors.select { |cell, n| n == 3 || (n == 2 && active_cubes.include?(cell)) }.keys
end

puts "Active cells: #{active_cubes.length}"
