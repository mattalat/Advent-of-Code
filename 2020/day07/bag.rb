# frozen_string_literal: true

class Bag
  attr_accessor :name, :contains

  class << self
    def bags
      @bags ||= []
    end

    def all
      bags
    end

    def find(target)
      bags.select { |b| b.name == target }.first
    end

    def parents_of(name)
      all.select { |b| b.can_contain? name }
    end
  end

  def initialize(name, contains)
    @name = name
    @contains = contains
    Bag.bags << self
  end

  def can_contain?(name)
    contains.any? { |c| c.match? name }
  end

  def bags_within
    contains.compact.map do |rule|
      next 0 if rule == 'no other'

      count = rule.match(/[0-9]+/)[0].to_i
      child_name = rule.gsub(/[0-9]+ /, '')
      count * (1 + Bag.find(child_name).bags_within)
    end.sum
  end
end
