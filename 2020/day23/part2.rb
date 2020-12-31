# frozen_string_literal: true

require_relative 'semi_circular_list'
require_relative 'diode'

input = '219748365'

N_CUPS = 1_000_000
N_ROUNDS = 10_000_000

cups = input.scan(/\d/).map(&:to_i)
cups += 10.upto(N_CUPS).to_a

list = SemiCircularList.new cups

def normalize(num)
  ((num - 1) % N_CUPS) + 1
end

N_ROUNDS.times do
  grabbed = list.take(3)
  grabbed_vals = [grabbed[0].val, grabbed[1].val, grabbed[2].val]

  desired = normalize(list.current.val - 1)
  desired = normalize(desired - 1) while grabbed_vals.include?(desired)

  list.step
  SemiCircularList.insert(grabbed, at_value: desired)
end

one = Diode.find 1

puts "\n#{one.nxt * one.nxt.nxt}"
