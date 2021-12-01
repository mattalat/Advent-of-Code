# frozen_string_literal: true

input = File.open(File.expand_path('input', __dir__)).readlines

depths = input.map(&:chomp).map(&:to_i)
increases = 0

depths.inject(depths.first) do |last, this|
  increases += 1 if this > last
  this
end

p increases
