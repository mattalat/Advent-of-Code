# frozen_string_literal: true

require_relative 'circular_list'
require_relative 'node'

input = '219748365'

number_of_cups = 1_000_000
number_of_rounds = 10_000_000

cups = input.scan(/\d/).map(&:to_i)
cups += 10.upto(number_of_cups).to_a

list = CircularList.new cups

1.upto(number_of_rounds).each do |n|
  print "\rTurn #{n}" if (n % (number_of_rounds / 100)).zero?

  grab = list.take(3)
  grabbed = [grab.val, grab.nxt.val, grab.prev.val]

  found = nil
  desired = list.current.val - 1
  list.current = list.current.nxt

  until found
    desired = number_of_cups if desired.zero?

    found = Node.find desired unless grabbed.include?(desired)
    desired -= 1
  end

  list.insert(grab, at: found)
end

one = Node.find 1

puts "\n#{one.nxt.val * one.nxt.nxt.val}"
