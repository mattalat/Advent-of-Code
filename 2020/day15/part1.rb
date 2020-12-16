# frozen_string_literal: true

input = '13,0,10,12,1,5,8'
numbers = input.split(',').map(&:to_i)

(numbers.length...2020).each do
  last = numbers.pop
  numbers.push(last, 0) and next unless numbers.include?(last)

  last_index = numbers.rindex(last)
  numbers.push(last, numbers.length - last_index)
end

puts numbers.last
