# frozen_string_literal: true

input = File.read(File.expand_path('input.txt', __dir__))
lines = input.split("\n").map(&:strip).compact

encounters = [
  { r: 1, d: 1 },
  { r: 3, d: 1 },
  { r: 5, d: 1 },
  { r: 7, d: 1 },
  { r: 1, d: 2 }
].map do |instr|
  i = count = 0

  lines.each_with_index do |line, j|
    next unless (j % instr[:d]).zero?

    count += 1 if line[i % line.length] == '#'
    i += instr[:r]
  end

  count
end

puts encounters.reduce(:*)
