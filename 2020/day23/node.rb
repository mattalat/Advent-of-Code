# frozen_string_literal: true

class Node
  def self.all
    @all ||= {}
  end

  def self.find(val)
    all[val]
  end

  attr_reader :val
  attr_accessor :nxt, :prev

  def initialize(val, prev: nil, nxt: nil)
    @val = val
    @prev = prev
    @nxt = nxt

    prev.nxt = self if prev
    nxt.prev = self if nxt

    Node.all[val] = self
  end

  def inspect
    "<Node #{val}, nxt: #{nxt&.val}, prev: #{prev&.val}>"
  end
end
