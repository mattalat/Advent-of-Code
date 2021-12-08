# frozen_string_literal: true

require 'set'
require 'active_support/core_ext/array'

input = File.open(File.expand_path('input', __dir__)).readlines.map(&:chomp)

displays = input.map { |l| l.split('|').map { _1.split(' ') } }

p displays.map(&:last).flat_map { _1.map(&:length) }.select { [2, 3, 4, 7].include? _1 }.count

numbers = displays.map do |wirings, outputs|
  wirings.map! { Set.new(_1.split('')) }
  outputs.map! { Set.new(_1.split('')) }

  mappings = {
    1 => wirings.find { _1.length == 2 },
    7 => wirings.find { _1.length == 3 },
    4 => wirings.find { _1.length == 4 },
    8 => wirings.find { _1.length == 7 }
  }

  wirings -= mappings.keys
  fives = wirings.select { _1.length == 5 }
  sixes = wirings.select { _1.length == 6 }

  mappings[9] = sixes.extract! { mappings[4].subset? _1 }.first
  mappings[0] = sixes.extract! { mappings[7].subset? _1 }.first
  mappings[6] = sixes.first

  mappings[5] = fives.extract! { mappings[6].superset? _1 }.first
  mappings[3] = fives.extract! { mappings[9].superset? _1 }.first
  mappings[2] = fives.first

  outputs.map { mappings.invert[_1] }.join.to_i
end

p numbers.sum
