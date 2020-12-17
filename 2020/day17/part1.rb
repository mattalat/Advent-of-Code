# frozen_string_literal: true

require_relative '../advent'

t0 = Advent.read.map { _1.split('') }
w = t0.length / 2
depth = 0
neighbors = [1, 1, 1, 0, 0, -1, -1, -1].permutation(3).to_a.uniq

# Get initial active cells

active_cubes = []

t0.length.times do |x|
  t0.length.times do |y|
    active_cubes << [x - w, y - w, depth] if t0[x][y] == '#'
  end
end

# Find new active cells for each cycle

6.times do |i|
  puts "Stage #{i + 1}"
  w += 1
  depth += 1
  new_active = []

  (-w).upto(w) do |x|
    (-w).upto(w) do |y|
      (-depth).upto(depth) do |z|
        active = neighbors.select { |c| active_cubes.include? [c[0] + x, y + c[1], z + c[2]] }.length
        if active_cubes.include?([x, y, z])
          new_active << [x, y, z] if (2..3).include?(active)
        elsif active == 3
          new_active << [x, y, z]
        end
      end
    end
  end

  active_cubes = new_active
end

puts active_cubes.map { _1.join(', ') }.length
