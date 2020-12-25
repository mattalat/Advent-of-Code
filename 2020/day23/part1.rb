# frozen_string_literal: true

input = '219748365'

cups = input.scan(/\d/).map(&:to_i)

1.upto(100).each do
  current = cups.shift
  picked = cups.shift(3)

  i = 1
  i += 1 until (desired = cups.index((current - i) < 1 ? cups.max + (current - i) : current - i))

  cups.insert(desired + 1, *picked)
  cups.push(current)
end

cups.push cups.shift until cups[0] == 1

puts cups[1..].join
