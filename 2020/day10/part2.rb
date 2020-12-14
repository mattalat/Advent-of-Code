# frozen_string_literal: true

require_relative '../advent'

raw = Advent.load_input_into_array.map(&:to_i).sort
jolts = raw.unshift(0).push(raw.max + 3)

class AdapterSet
  attr_reader :adapters

  def initialize(adapters)
    @adapters = adapters
  end

  def adapter_cache
    @adapter_cache ||= {}
  end

  def valid_permutations(from = adapters[0])
    return adapter_cache[from] if adapter_cache.key? from
    return adapter_cache[from] = 1 if next_indices(from).empty?

    adapter_cache[from] = next_indices(from).map { |i| valid_permutations(adapters[i]) }.sum
  end

  def next_indices(adapter)
    (adapters.index(adapter) + 1...adapters.size)
      .select { |i| adapter < adapters[i] }
      .select { |i| adapters[i] <= adapter + 3 }
      .take(3)
  end
end

puts AdapterSet.new(jolts).valid_permutations
