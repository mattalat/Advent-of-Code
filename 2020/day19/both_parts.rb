# frozen_string_literal: true

require_relative '../advent'

input = Advent.read.map(&:strip)

rules = input.select { _1 =~ /^\d/ }.compact
messages = (input - rules - ['']).compact

rule_hash = {}

rules.each do |rule|
  num, rule_string = rule.split(': ')
  rule_hash[num] = rule_string
end

class Checker
  attr_accessor :rule_hash

  def initialize(rule_hash)
    @rule_hash = rule_hash
  end

  def check_rule(rule)
    r = rule_hash[rule]
    return r[1] if r.length == 3

    tokens = r.split.map do |t|
      t == '|' ? '|' : check_rule(t)
    end.join

    "(#{tokens})"
  end
end

checker = Checker.new(rule_hash)
zero = checker.check_rule('0')

puts messages.select { _1.match? "^#{zero}$" }.count

# Use trial and error to find out how far out to bear the recursion

new_rule_hash = rule_hash.dup
new_rule_hash['8'] = '42 | 42 42 | 42 42 42 | 42 42 42 42 | 42 42 42 42 42'
new_rule_hash['11'] = '42 31 | 42 42 31 31 | 42 42 42 31 31 31 | 42 42 42 42 31 31 31 31 | 42 42 42 42 42 31 31 31 31 31'

new_checker = Checker.new(new_rule_hash)
nz = new_checker.check_rule('0')

puts messages.select { _1.match? "^#{nz}$" }.count
