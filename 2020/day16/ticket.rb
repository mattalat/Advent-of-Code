# frozen_string_literal: true

require 'byebug'

class Ticket
  attr_accessor :numbers, :rules

  def initialize(string, rules)
    @numbers = string.split(',').map(&:to_i)
    @rules = rules
  end

  def valid?
    invalid_numbers.empty?
  end

  def invalid_numbers
    numbers.reject { |n| rules.values.flatten.any? { _1.include? n } }
  end

  # Returns an Array where each element is [number, potential labels]
  def find_potential_rules
    numbers.map do |num|
      [].tap do |arr|
        arr << num
        arr << rules.flat_map { |label, ranges| label if ranges.any? { _1.include? num } }
      end
    end
  end
end
