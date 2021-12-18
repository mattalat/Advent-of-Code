# frozen_string_literal: true

input = File.open(File.expand_path('input', __dir__)).readlines.map(&:chomp).first

pos = input.split(',').map(&:to_i)

costs = (pos.min..pos.max).map do |p|
  delta = pos.map { |x| (p - x).abs }
  [delta.sum, delta.sum { |n| ((n**2) + n) / 2.0 }]
end

puts costs.map(&:first).min
puts costs.map(&:last).min
