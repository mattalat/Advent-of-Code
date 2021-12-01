# frozen_string_literal: true

input = File.open(File.expand_path('input', __dir__)).readlines

depths = input.map(&:chomp).map(&:to_i)
slices = depths.each_cons(3).to_a
p slices[..-2].zip(slices[1..]).map { _1.sum - _2.sum }.count(&:negative?)
