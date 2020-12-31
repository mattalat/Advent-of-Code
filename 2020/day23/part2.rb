# frozen_string_literal: true

input = '219748365'

N_CUPS = 1_000_000
N_ROUNDS = 10_000_000

# Wrap num around N_CUPS such that the output is bound [1, N_CUPS]
def normalize(num)
  ((num - 1) % N_CUPS) + 1
end

starting_cups = input.scan(/\d/).map(&:to_i)

cups = Array.new(N_CUPS + 1) { |i| i + 1 }
starting_cups.zip(starting_cups[1..]).each { |cup, points_to| cups[cup] = points_to }

cups[0] = starting_cups.first
cups[starting_cups.last] = starting_cups.length + 1
cups[-1] = cups[0]

# We now have an array of length N_CUPS + 1.
#
# The first index contains the current cup's label.
#
# Each index after zero represents the cup with that label. The value of the
# array at that index is the value of the next cup.
#
# If cups[2] == 50, that would mean that that cup 50 was next after cup 2. We
# could look at cups[50] to find out what cup was next in the sequence, etc.

N_ROUNDS.times do
  current = cups[0]

  # 'Grab' the next three cups
  first = cups[current]
  second = cups[first]
  third = cups[second]

  # Stitch up the simple linked list so the current cup points at the 4th neighbor.
  tail = cups[third]
  cups[current] = tail

  # Find the next candidate label
  candidate = normalize(current - 1)
  candidate = normalize(candidate - 1) while [first, second, third].include?(candidate)

  # Insert the three cups we grabbed after the candidate cup
  tail = cups[candidate]
  cups[candidate] = first
  cups[third] = tail

  # Move on to the next cup after the current
  cups[0] = cups[current]
end

# The product of the two labels after '1'
puts cups[1] * cups[cups[1]]
