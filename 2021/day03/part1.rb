# frozen_string_literal: true

input = File.open(File.expand_path('input', __dir__)).readlines.map(&:chomp)

max = (2**input[0].length) - 1
gamma = input.map { _1.split('') }.transpose.map(&:tally).map { |count| count.max_by(&:last).first }.join.to_i(2)

p gamma * (max - gamma)
