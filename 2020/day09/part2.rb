# frozen_string_literal: true

# Load input
input = File.read(File.expand_path('input.txt', __dir__))
lines = input.split("\n").map(&:strip).map(&:to_i)

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
