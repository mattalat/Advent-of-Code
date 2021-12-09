# frozen_string_literal: true

input = File.open(File.expand_path('input', __dir__)).readlines.map(&:chomp)

pts = input.map { _1.split('').map(&:to_i) }
pts.unshift(Array.new(pts[0].length, 9))
pts.push(Array.new(pts[0].length, 9))
pts.map! { [9, *_1, 9] }
mins = []

def neighbors(x1, y1)
  [[x1 - 1, y1], [x1 + 1, y1], [x1, y1 - 1], [x1, y1 + 1]]
end

(1...pts.length - 1).each do |i|
  (1...pts[0].length - 1).each do |j|
    cell = pts[i][j]
    mins << [i, j, cell] if neighbors(i, j).all? { cell < pts[_1][_2] }
  end
end

p mins.map { _1.pop + 1 }.sum

class Basin
  attr_reader :pts, :x, :y, :visited

  def initialize(pts, x, y)
    @pts = pts
    @x = x
    @y = y
    @visited = []
  end

  def size(x1 = x, y1 = y)
    current = pts[x1][y1]
    visited << [x1, y1]

    neighbors(x1, y1).sum do |x2, y2|
      neighbor = pts[x2][y2]
      next 0 if neighbor == 9 || current > neighbor || visited.include?([x2, y2])

      size(x2, y2)
    end + 1
  end
end

basins = mins.map { |i, j| Basin.new(pts, i, j).size }

p basins.sort[-3..].reduce(:*)
