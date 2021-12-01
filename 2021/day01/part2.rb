# frozen_string_literal: true

input = File.open(File.expand_path('input', __dir__)).readlines

depths = input.map(&:chomp).map(&:to_i)
p depths.each_cons(3).each_cons(2).map { _1.sum - _2.sum }.count(&:negative?)
