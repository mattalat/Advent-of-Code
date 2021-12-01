# frozen_string_literal: true

input = File.open(File.expand_path('input', __dir__)).readlines

depths = input.map(&:chomp).map(&:to_i)

p depths.zip(depths[1..]).map { _1.compact.reduce(&:-) }.count(&:negative?)
