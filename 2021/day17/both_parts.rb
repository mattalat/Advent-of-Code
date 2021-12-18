# frozen_string_literal: true

input = File.open(File.expand_path('input', __dir__)).readlines.map(&:chomp).first

BOUNDS = input.slice(input.index('x')..).split(', ').map { _1.scan(/-*\d+/).map(&:to_i) }
AREA = { x: Range.new(*BOUNDS[0].sort), y: Range.new(*BOUNDS[1].sort) }.freeze

def step(x, y, vx, vy)
  x += vx
  y += vy
  vx -= 1 unless vx.zero?
  vy -= 1

  [x, y, vx, vy]
end

def in_area?(x, y)
  AREA[:x].cover?(x) && AREA[:y].cover?(y)
end

def past_area?(x, y)
  y < AREA[:y].min || x > AREA[:x].max
end

def step_till_bounds(vx, vy)
  x = 0
  y = 0

  x, y, vx, vy = step(x, y, vx, vy) until in_area?(x, y) || past_area?(x, y)

  in_area?(x, y)
end

min_vx = (-0.5 + Math.sqrt(0.25 + (2 * AREA[:x].min))).ceil
max_vx = AREA[:x].max
min_vy = AREA[:y].min
max_vy = (-1 * min_vy) - 1

viable = (min_vx..max_vx).map do |vx|
  (min_vy..max_vy).map do |vy|
    [vx, vy] if step_till_bounds(vx, vy)
  end
end.flatten(1).compact

p (((max_vy**2) + max_vx) / 2.0) - 1
p viable.length
