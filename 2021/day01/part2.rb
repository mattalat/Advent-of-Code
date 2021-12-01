# frozen_string_literal: true

input = File.open(File.expand_path('input', __dir__)).readlines

depths = input.map(&:chomp).map(&:to_i)
increases = 0

depths[3..].inject(depths[..2]) do |window, this|
  new_window = [window[-2], window[-1], this].compact
  increases += 1 if new_window.sum > window.sum
  new_window
end

p increases
