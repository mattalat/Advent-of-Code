# frozen_string_literal: true

input = File.open(File.expand_path('input', __dir__)).readlines.map(&:chomp)

vecs = input.map { |l| l.split(' -> ').flat_map { _1.scan(/(\d+),(\d+)/).map { |coords| coords.map(&:to_i) } } }
linears = vecs.select { |s, e| s[0] == e[0] || s[1] == e[1] }
diagonals = vecs.select { |s, e| (s[0] - e[0]).abs == (s[1] - e[1]).abs }

submap = Array.new(1000) { Array.new(1000, 0) }

linears.each do |from, to|
  if from.first == to.first
    Range.new(*[from.last, to.last].sort).each { |i| submap[from.first][i] += 1 }
  elsif from.last == to.last
    Range.new(*[from.first, to.first].sort).each { |j| submap[j][from.last] += 1 }
  end
end

puts submap.map { |r| r.count { _1 > 1 } }.sum

diagonals.each do |from, to|
  diff = [to.first - from.first, to.last - from.last]
  mag = diff.first.magnitude
  diff = [diff.first / mag, diff.last / mag]

  points = 0.upto(mag).each_with_object([]) do |i, acc|
    acc << [from.first + i * diff.first, from.last + i * diff.last]
  end

  points.each { |i, j| submap[i][j] += 1 }
end

puts submap.map { |r| r.count { _1 > 1 } }.sum
