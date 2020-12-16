# frozen_string_literal: true

require_relative '../advent'

raw = Advent.read

memory = {}

indices = raw.each_with_index.select { |el, _| el =~ /mask/ }.map(&:last)
groups = indices.zip(indices[1..]).map { |s, e| (s...e) }.map { |r| raw[r] }

groups.each do |group|
  mask = group[0].scan(/mask = (.+)/)[0].first

  group[1..].each do |assignment|
    nums = assignment.scan(/\d+/)
    addr = nums[0]
    val = format("%0#{mask.length}d", nums[1].to_i.to_s(2))

    new_val = mask.split('')
                  .zip(val.split(''))
                  .map { |mbit, obit| mbit == 'X' ? obit : mbit }
                  .join
                  .to_i(2)
                  .to_s(10)

    memory[addr] = new_val
  end
end

puts memory.values.map(&:to_i).sum
