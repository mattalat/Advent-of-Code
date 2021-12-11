# frozen_string_literal: true

input = File.open(File.expand_path('input', __dir__)).readlines.map(&:chomp)

class Cave
  attr_accessor :map, :flashed, :flashes

  def initialize(map)
    @map = map
    @rmax = map.length - 1
    @cmax = map.first.length - 1
    @flashed = []
    @flashes = 0
  end

  def step(steps = 1)
    steps.times do
      step_once
      self.flashes += flashed.length
    end
  end

  def steps_until_sync
    1 + (0..).find do
      step_once
      flashed.length == map.length * map.first.length
    end
  end

  private

  def step_once
    self.flashed = []

    (0..@rmax).each do |x|
      (0..@cmax).each do |y|
        map[x][y] += 1 unless flashed.include? [x, y]
        flash(x, y) if map[x][y] > 9
      end
    end
  end

  def neighbors(x, y)
    vectors = [-1, 0, 1].repeated_permutation(2).to_a
    vectors -= [[0, 0]]
    vectors.map { |vx, vy| [x + vx, y + vy] }
           .select { |nx, ny| nx <= @rmax && nx >= 0 && ny <= @cmax && ny >= 0 }
  end

  def flash(x, y)
    map[x][y] = 0
    flashed << [x, y]

    neighbors(x, y).each do |nx, ny|
      map[nx][ny] += 1 unless flashed.include? [nx, ny]
      flash(nx, ny)    if map[nx][ny] > 9
    end
  end
end

cave = Cave.new(input.map(&:chars).map { _1.map(&:to_i) })
cave.step(100)

p cave.flashes
p cave.steps_until_sync + 100
