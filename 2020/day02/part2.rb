# frozen_string_literal: true

input = File.read(File.expand_path('input.txt', __dir__))
lines = input.split("\n").map(&:strip).compact

passing_passwords = lines.select do |line|
  policy, pass = line.split(': ')
  spec, char   = policy.split(' ')
  first, last  = spec.split('-').map(&:to_i).map { _1 - 1 }

  [pass[first], pass[last]].select { _1 == char }.one?
end

puts passing_passwords.count
