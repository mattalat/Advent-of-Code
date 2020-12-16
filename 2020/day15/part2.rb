# frozen_string_literal: true

input       = '13,0,10,12,1,5,8'
numbers     = input.split(',').map(&:to_i)
spoken      = numbers[0..-2].uniq.map { |u| { u => numbers.index(u) + 1 } }.reduce(&:merge)
spoken_last = numbers.last

(numbers.length + 1..30_000_000).each do |i|
  last_round          = i - 1
  speak_next          = spoken[spoken_last] ? (last_round - spoken[spoken_last]) : 0
  spoken[spoken_last] = last_round
  spoken_last         = speak_next
end

puts spoken_last
