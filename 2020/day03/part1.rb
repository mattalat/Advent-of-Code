# frozen_string_literal: true

input = File.read(File.expand_path('input.txt', __dir__))
lines = input.split("\n").map(&:strip).compact

width = lines[0].length
i = count = 0

lines.each do |line|
  count += 1 if line[i % width] == '#'
  i += 3
end

puts count
