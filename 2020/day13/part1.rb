# frozen_string_literal: true

require_relative '../advent'

raw = Advent.load_input_into_array

epoch  = raw[0].to_i
busses = raw[1].scan(/\d+/).map(&:to_i)

times = busses.map do |bus|
  nearest = bus * (epoch / bus)
  nearest < epoch ? nearest + bus : nearest
end

puts (times.min - epoch) * busses[times.index(times.min)]
