# frozen_string_literal: true

class Diode
  def self.all
    @all ||= {}
  end

  def self.find(val)
    val ? all[val] : nil
  end

  attr_reader :val
  attr_accessor :nxt

  def initialize(val, nxt: nil)
    @val = val
    @nxt = nxt
    Diode.all[val] = self
  end

  def inspect
    "<Diode #{val}, nxt: #{nxt&.val}>"
  end

  def *(other)
    val * other.val
  end
end
