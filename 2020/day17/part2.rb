# frozen_string_literal: true

require_relative '../advent'

raw = Advent.read.map(&:strip)
cubes = Hash.new('.')

raw.each.with_index do |row, x|
  row.each_char.with_index { |c, y| cubes[[x, y, 0, 0]] = c }
end

def min_max(coords)
  dimensions = %i[x y z t]
  maxes = {}
  mins  = {}

  dimensions.each_with_index do |d, i|
    dimension_vector = coords.map { _1[i] }
    mins[d]  = dimension_vector.min - 1
    maxes[d] = dimension_vector.max + 1
  end

  [mins, maxes]
end

directions = [-1, 0, 1].repeated_permutation(4).to_a - [[0] * 4]

6.times do
  occupied_spaces = cubes.keys
  mins, maxes = min_max(occupied_spaces)

  future = cubes.dup

  mins[:x].upto(maxes[:x]).each do |x|
    mins[:y].upto(maxes[:y]).each do |y|
      mins[:z].upto(maxes[:z]).each do |z|
        mins[:t].upto(maxes[:t]).each do |t|
          neighbors = directions.count do |dx, dy, dz, dt|
            cubes[[x + dx, y + dy, z + dz, t + dt]] == '#' && ![dx, dy, dz, dt].all?(&:zero?)
          end

          future[[x, y, z, t]] = case cubes[[x, y, z, t]]
                                 when '#' then (2..3).include?(neighbors) ? '#' : '.'
                                 when '.' then neighbors == 3 ? '#' : '.'
                                 end
        end
      end
    end
  end

  cubes = future
end

puts(cubes.values.count { _1 == '#' })
