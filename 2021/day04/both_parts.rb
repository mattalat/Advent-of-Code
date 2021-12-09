# frozen_string_literal: true

input = File.open(File.expand_path('input', __dir__)).readlines.map(&:chomp).reject(&:empty?)

draws = input.shift.scan(/\d+/).map(&:to_i)
boards = input.each_slice(5).map { |board| board.map { _1.scan(/\d+/).map(&:to_i) } }
scores = []

def board_wins?(board)
  board.any? { |row| row.compact.empty? } || board.transpose.any? { |col| col.compact.empty? }
end

until boards.empty?
  draw =  draws.shift

  boards.reject! do |board|
    board.each { |row| row.each_with_index { |cell, j| row[j] = nil if cell == draw } }
    next false unless board_wins?(board)

    scores << (board.flat_map(&:compact).sum * draw)
  end
end

puts scores.first
puts scores.last
