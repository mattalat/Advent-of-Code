# frozen_string_literal: true

require 'matrix'
require 'ostruct'

input = File.open(File.expand_path('input', __dir__)).readlines.join
parsed = input.scan(/(\w+).(\d+)/).map { [_1, _2.to_i] }
submarine = OpenStruct.new(pos: Vector[0, 0], aim: 0)

parsed.each_with_object(submarine) do |instr, n|
  direction, amt = instr

  if direction =~ /^f/
    n.pos += Vector[n.aim * amt, amt]
  else
    n.aim += direction =~ /^u/ ? amt * -1 : amt
  end
end

p submarine.pos.reduce(&:*)
