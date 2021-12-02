# frozen_string_literal: true

require 'matrix'
require 'ostruct'

input = File.open(File.expand_path('input', __dir__)).readlines.join
parsed = input.scan(/(\w+).(\d+)/).map { [_1, _2.to_i] }
submarine = OpenStruct.new(pos: Vector[0, 0], aim: 0)

parsed.each do |direction, amt|
  submarine.pos += Vector[submarine.aim * amt, amt] if direction =~ /^f/
  submarine.aim += direction =~ /^u/ ? amt * -1 : amt if direction =~ /^[u,d]/
end

p submarine.pos.reduce(&:*)
