# frozen_string_literal: true

require 'byebug'

class Ticket
  attr_accessor :numbers, :rules

  def initialize(string, rules)
    @numbers = string.split(',').map(&:to_i)
    @rules = rules.clone
  end

  def valid?
    invalid_numbers.empty?
  end

  def invalid_numbers
    numbers.clone.reject do |number|
      rules.values.flatten.any? { |r| r.include? number }
    end
  end

  def find_potential_rules
    numbers.clone.map do |num|
      [num, []].tap do |arr|
        rules.each { |k, ranges| arr[1].push(k) if ranges.any? { _1.include? num } }
      end
    end
  end
end
