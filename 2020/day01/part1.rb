# frozen_string_literal: true

input = File.read(File.expand_path('input.txt', __dir__))

set = input.split("\n").compact.map(&:strip).map(&:to_i).uniq

puts set.select { |x| set.include? 2020 - x }.reduce(1, :*)
