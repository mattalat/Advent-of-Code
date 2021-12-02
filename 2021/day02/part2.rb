# frozen_string_literal: true

require 'matrix'
require 'ostruct'

input = File.open(File.expand_path('input', __dir__)).readlines.join

submarine = OpenStruct.new(pos: Vector[0, 0], aim: 0)

input.scan(/(\w).+(\d+)/).map { [_1.to_sym, _2.to_i] }.each do |d, amt|
  submarine.pos += Vector[submarine.aim * amt, amt] if d == :f
  submarine.aim += { f: 0, d: 1, u: -1 }[d] * amt
end

p submarine.pos.reduce(&:*)
