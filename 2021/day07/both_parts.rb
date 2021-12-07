# frozen_string_literal: true

input = File.open(File.expand_path('input', __dir__)).readlines.map(&:chomp).first

pos = input.split(',').map(&:to_i)

costs = pos.min.upto(pos.max).map do |p|
  [p, pos.map { |x| (p - x).abs }.sum]
end

puts costs.min_by(&:last).last

costs = pos.min.upto(pos.max).map do |p|
  cost = pos.map do |x|
    n = (p - x).abs
    n / 2.0 * (2 + n - 1)
  end

  [p, cost.sum]
end

puts costs.min_by(&:last).last
