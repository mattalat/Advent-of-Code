# frozen_string_literal: true

require 'set'

input = File.open(File.expand_path('input', __dir__)).readlines.map(&:chomp)

displays = input.map { |l| l.split('|').map { _1.split(' ') } }

p displays.map(&:last).flat_map { _1.map(&:length) }.select { [2, 3, 4, 7].include? _1 }.count

numbers = displays.map do |wirings, outputs|
  wirings.map! { |w| Set.new(w.split('')) }
  outputs.map! { |w| Set.new(w.split('')) }

  mappings = {
    1 => wirings.find { _1.length == 2 },
    7 => wirings.find { _1.length == 3 },
    4 => wirings.find { _1.length == 4 },
    8 => wirings.find { _1.length == 7 }
  }

  wirings -= mappings.keys
  fives = wirings.select { _1.length == 5 }
  sixes = wirings.select { _1.length == 6 }

  mappings[9] = sixes.find { mappings[4].subset? _1 }
  sixes -= [mappings[9]]
  mappings[0] = sixes.find { mappings[7].subset? _1 }
  sixes -= [mappings[0]]
  mappings[6] = sixes.first

  mappings[5] = fives.find { mappings[6].superset? _1 }
  fives -= [mappings[5]]
  mappings[3] = fives.find { mappings[9].superset? _1 }
  fives -= [mappings[3]]
  mappings[2] = fives.first

  outputs.map { mappings.invert[_1] }.join.to_i
end

p numbers.reduce(:+)
