# frozen_string_literal: true

input = File.open(File.expand_path('input', __dir__)).readlines.map(&:chomp)

draws = input.shift.scan(/\d+/)
boards = input[1..].each_slice(6).map(&:to_a).map { _1[0..-2] }.map { |board| board.map { _1.scan(/\d+/) } }
draw = nil

def board_wins?(board)
  board.any? { |row| row.compact.empty? } || board.transpose.any? { |col| col.compact.empty? }
end

while boards.length > 1
  draw = draws.shift

  boards.reject! do |board|
    board.each { |row| row.each_with_index { |cell, j| row[j] = nil if cell == draw } }
    board_wins?(board)
  end
end

last_board = boards[0]

until board_wins?(last_board)
  draw = draws.shift
  last_board.each do |row|
    row.each_with_index { |cell, j| row[j] = nil if cell == draw }
  end
end

p last_board.map(&:compact).map { _1.map(&:to_i).sum }.sum * draw.to_i
