# frozen_string_literal: true

input = File.read(File.expand_path('input.txt', __dir__))

set = input.split("\n").compact.map(&:strip).map(&:to_i).uniq

set.each do |x|
  complements = (set - [x]).select { |y| set.include?(2020 - x - y) }
  next if complements.empty?

  puts complements.push(x).reduce(1, :*)
  break
end
