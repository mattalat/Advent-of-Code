# frozen_string_literal: true

require_relative '../advent'

lines = Advent.load_input_into_array.map(&:to_i)

target = `ruby part1.rb`.strip.to_i

sliding_window = [lines.shift]

until lines.empty?
  if sliding_window.sum == target
    puts sliding_window.min + sliding_window.max
    break
  elsif sliding_window.sum < target
    sliding_window.push(lines.shift)
  else
    sliding_window.shift
  end
end
