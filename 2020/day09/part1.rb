# frozen_string_literal: true

# Load input
input = File.read(File.expand_path('input.txt', __dir__))
lines = input.split("\n").map(&:strip).map(&:to_i)

def window_can_sum?(window, num)
  window.any? do |x|
    target = num - x
    (window - [x]).include? target
  end
end

width = 25
window = lines[0..width - 1]

lines[width..-1].find do |n|
  puts n unless window_can_sum?(window, n)

  window.shift
  window.push(n)
  false
end
