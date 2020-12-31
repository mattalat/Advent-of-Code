# frozen_string_literal: true

require_relative 'diode'

class SemiCircularList
  attr_reader :current

  def initialize(arr)
    prev = @current = Diode.new(arr.first)

    arr[1..-2].each do |n|
      diode = Diode.new(n)
      prev.nxt = diode
      prev = diode
    end

    prev.nxt = Diode.new arr.last
    prev.nxt.nxt = @current
  end

  def advance(steps = 1)
    steps.times { step }
  end

  def step
    @current = current.nxt
  end

  def take(num)
    nxt = current
    section = num.times.map { nxt = nxt.nxt }

    current.nxt = section.last.nxt
    section.last.nxt = section.first

    section
  end

  def self.insert(section, at_value:)
    at = Diode.find(at_value)
    old_tip = at.nxt
    at.nxt = section.first
    section.last.nxt = old_tip
  end
end
