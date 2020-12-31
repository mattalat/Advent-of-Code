# frozen_string_literal: true

require_relative '../advent'

input = Advent.read.map(&:strip)

rules = input.select { _1 =~ /^\d/ }.compact
messages = (input - rules - ['']).compact
rule_hash = rules.to_h { _1.split(': ') }

class Checker
  def self.extract_rule(starting, rules:)
    new(rules).check_rule(starting)
  end

  def initialize(rules)
    @rules = rules.dup
  end

  def check_rule(starting)
    rule = @rules[starting]
    return rule[1] if rule.include?('"')

    tokens = rule.split.map do |token|
      token == '|' ? '|' : check_rule(token)
    end

    "(#{tokens.join})"
  end
end

# Part 1

zeroth = Checker.extract_rule('0', rules: rule_hash)
zero_regex = /^#{zeroth}$/
puts(messages.count { _1.match? zero_regex })

# Part 2

# Since we can't handle infinite recursion, find out how far recursion carries
# on rules 8/11. To do so, find when the results stop changing when run
# against our input.
#
# In practice, each rule stops yielding different results after 4
# self-references, so we'll modify them as such.

rule_hash['8']  = (1..5).map { ' 42 ' * _1 }.join('|').strip
rule_hash['11'] = (1..5).map { ' 42 ' * _1 + '31 ' * _1 }.join('|').strip

zeroth = Checker.extract_rule('0', rules: rule_hash)
zero_regex = /^#{zeroth}$/
puts(messages.count { _1.match? zero_regex })
