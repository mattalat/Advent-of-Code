# frozen_string_literal: true

require_relative 'circular_list'
require_relative 'node'

input = '219748365'

N_CUPS = 1_000_000
N_ROUNDS = 10_000_000

cups = input.scan(/\d/).map(&:to_i)
cups += 10.upto(N_CUPS).to_a

list = CircularList.new cups

N_ROUNDS.times do
  grabbed = list.take(3)
  grabbed_vals = [grabbed[0].val, grabbed[1].val, grabbed[2].val]

  found = nil
  desired = list.current.val - 1
  list.current = list.current.nxt

  until found
    desired = N_CUPS if desired.zero?

    found = Node.find desired unless grabbed_vals.include?(desired)
    desired -= 1
  end

  CircularList.insert(grabbed[0], at: found)
end

one = Node.find 1

puts "\n#{one.nxt.val * one.nxt.nxt.val}"
