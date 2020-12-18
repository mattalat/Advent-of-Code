# frozen_string_literal: true

require_relative '../advent'
require_relative 'parsely'

input = Advent.read

puts "Part 1: #{input.map(&Parsely.method(:evaluate)).sum}"

# Same for part 2, just modify precedence of '+'
part2 = input.map do |string|
  Parsely.new(string).then do |bit_o_parsely|
    bit_o_parsely.precedence['+'] = 2
    bit_o_parsely.parse
  end
end

puts "Part 2: #{part2.map(&Parsely.method(:evaluate)).sum}"
