# frozen_string_literal: true

require 'active_support/core_ext/object'
require 'active_support/core_ext/array'
require 'fc'

input = File.open(File.expand_path('input', __dir__)).readlines.map(&:chomp)

class Solver
  attr_reader :coords, :w, :h, :source, :destination
  attr_accessor :graph, :pq

  def initialize(coords)
    @w = coords.first.length
    @h = coords.length
    @coords = coords.flatten

    # Graph nodes are stored as follows:
    # 0       1                     2
    # index   distance from source  previous node
    @graph = (0...@coords.length).map { |i| [i, Float::INFINITY, nil] }

    @graph[0][1] = 0
    @source = 0
    @destination = @coords.length - 1
    @pq = FastContainers::PriorityQueue.new(:min)
    @pq.push(graph[0], graph[0][1])
  end

  def solve
    dijkstra
    calculate_risk
  end

  private

  def adjacent_to(xy)
    [
      (xy - w if xy >= w),
      (xy + w if xy < (w * h) - w),
      (xy + 1 unless ((xy + 1) % w).zero?),
      (xy - 1 unless (xy % w).zero?)
    ].compact
  end

  def dijkstra
    until pq.empty?
      u = pq.pop
      return if u == destination

      adjacent_to(u[0]).each do |c|
        v = graph[c]
        alt = u[1] + coords[v[0]]
        next unless v[1] > alt

        v[1] = alt
        v[2] = u[0]
        pq.push(v, alt)
      end
    end
  end

  def calculate_risk
    u = destination
    stack = []

    while u.present?
      stack.push(u)
      u = graph[u][2]
    end

    stack.map { coords[_1] }.sum - coords[source]
  end
end

# Part 1 input
coords = input.map(&:chars).map { _1.map(&:to_i) }

# Part 2 input
tick_up = proc { |n, amt|
  add = n + amt
  add > 9 ? add % 9 : add
}
new_col    = (0...5).map { |n| coords.map { |r| r.map { |i| tick_up.call(i, n) } } }.flatten(1)
new_cols   = (0...5).map { |n| new_col.map { |r| r.map { |i| tick_up.call(i, n) } } }
new_coords = new_cols.map(&:transpose).reduce(:+).transpose

p Solver.new(coords).solve
p Solver.new(new_coords).solve
