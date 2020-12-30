# frozen_string_literal: true

require_relative '../advent'

input = Advent.read

card = input[0].to_i
door = input[1].to_i

N = 20201227
SUBJECT = 7

def one_encryption(val)
  (val * SUBJECT) % N
end

def encrypt(subject, loop_times)
  (1..loop_times).reduce(1) do |acc|
    (subject * acc) % N
  end
end

acc = 1
card_loops = (1..).find do
  acc = one_encryption(acc)
  acc == card
end

# Confirm by calculating door_loops and asserting that:
#   encrypt(door, card_loops) == encrypt(card, door_loops)

puts encrypt(door, card_loops)
