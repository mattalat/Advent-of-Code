# frozen_string_literal: true

input = File.open(File.expand_path('input', __dir__)).readlines.map(&:chomp)

pts = input.map { _1.chars.map(&:to_i) }
pts.unshift(Array.new(pts[0].length, 9))
pts.push(Array.new(pts[0].length, 9))
pts.map! { [9, *_1, 9] }

def neighbors(x1, y1)
  [[x1 - 1, y1], [x1 + 1, y1], [x1, y1 - 1], [x1, y1 + 1]]
end

mins = []
(1...pts.length - 1).each do |i|
  (1...pts[0].length - 1).each do |j|
    cell = pts[i][j]
    mins << [i, j, cell] if neighbors(i, j).all? { cell < pts[_1][_2] }
  end
end

p mins.map(&:pop).sum { _1 + 1 }

# Part 2

class Basin
  attr_reader :x, :y, :visited

  def initialize(x, y)
    @x = x
    @y = y
    @visited = []
  end

  def size(x1 = x, y1 = y)
    current = PTS[x1][y1]
    visited << [x1, y1]

    neighbors(x1, y1).sum do |x2, y2|
      neighbor = PTS[x2][y2]
      next 0 if neighbor == 9 || current > neighbor || visited.include?([x2, y2])

      size(x2, y2)
    end + 1
  end
end

PTS = pts.clone.freeze
sizes = mins.map { |i, j| Basin.new(i, j).size }

p sizes.sort[-3..].reduce(:*)
