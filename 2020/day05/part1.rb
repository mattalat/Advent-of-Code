# frozen_string_literal: true

# Load input
input = File.read(File.expand_path('input.txt', __dir__))
lines = input.split("\n").map(&:strip).compact

# Empty seats
seats = []
128.times { seats << Array.new(8, 0) }

decoding = {
  'F' => '0',
  'B' => '1',
  'L' => '0',
  'R' => '1'
}

lines.each do |line|
  row = line[0..6].chars.map { |c| decoding[c] }.join.to_i(2)
  col = line[7..-1].chars.map { |c| decoding[c] }.join.to_i(2)
  seats[row][col] = row * 8 + col
end

# Print seat map
seats.each { |row| puts row.join(', ') }

puts "\nMax seat ID: #{seats.map { _1.max }.max}"
