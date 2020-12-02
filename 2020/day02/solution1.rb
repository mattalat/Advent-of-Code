# frozen_string_literal: true

input = File.read(File.expand_path('input.txt', __dir__))
lines = input.split("\n").map(&:strip).compact

passing_passwords = lines.select do |line|
  policy, pass = line.split(': ')
  count, char  = policy.split(' ')
  min, max     = count.split('-').map(&:to_i)

  tally = pass.split(//).tally
  tally.key?(char) && (min..max).cover?(tally[char])
end

puts passing_passwords.count
