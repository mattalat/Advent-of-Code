# frozen_string_literal: true

input = File.open(File.expand_path('input', __dir__)).readlines.map(&:chomp)

vecs = input.map { |l| l.split(' -> ').flat_map { _1.scan(/(\d+),(\d+)/).map { |coords| coords.map(&:to_i) } } }

card_map = Array.new(1000) { Array.new(1000, 0) }
all_map  = Array.new(1000) { Array.new(1000, 0) }

vecs.each do |from, to|
  dx = to[0] - from[0]
  dy = to[1] - from[1]
  len = [dx, dy].map(&:magnitude).max
  dx /= len
  dy /= len

  0.upto(len).each do |i|
    card_map[from[0] + dx * i][from[1] + dy * i] += 1 if from[0] == to[0] || from[1] == to[1]
    all_map[from[0] + dx * i][from[1] + dy * i] += 1
  end
end

p card_map.flatten.select { _1 > 1 }.count
p all_map.flatten.select { _1 > 1 }.count
