# frozen_string_literal: true

require_relative '../advent'

raw = Advent.read

memory = {}
group_indices = raw.each_with_index.select { |el, _| el =~ /mask/ }.map(&:last)
groups = group_indices.zip(group_indices[1..]).map { raw[_1..._2] }

# Expands the 'X' floating bits in an address to all 2**count('X') permutations
def floating_bits_to_real(addr)
  sp = addr.clone
  xs = sp.each_index.select { |el| sp[el] == 'X' }
  permutations = [1, 0].product(*(1...xs.count).map { [1, 0] })

  permutations.map do |perm|
    sp.clone.then do |new_addr|
      xs.each_with_index { |x, i| new_addr[x] = perm[i] }
      new_addr.join.to_i(2)
    end
  end
end

# Apply masks to each group
groups.each do |group|
  mask = group[0].scan(/mask = (.+)/)[0].first

  group[1..].each do |assignment|
    nums = assignment.scan(/\d+/)
    addr = format("%0#{mask.length}d", nums[0].to_i.to_s(2))
    val = nums[1].to_i

    naddr = mask.split('').zip(addr.split('')).map do |mbit, obit|
      case mbit
      when 'X' then 'X'
      when '0' then obit
      when '1' then '1'
      end
    end

    floating_bits_to_real(naddr).each { |a| memory[a] = val }
  end
end

puts memory.values.map(&:to_i).sum
