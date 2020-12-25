# frozen_string_literal: true

class CircularList
  attr_accessor :current

  def initialize(arr)
    prev_node = @current = Node.new(arr.first)

    arr[1..-2].each do |n|
      node = Node.new(n, prev: prev_node)
      prev_node.nxt = node
      prev_node = node
    end

    last_node = Node.new(arr.last, nxt: @current, prev: prev_node)
    @current.prev = last_node
  end

  def take(num)
    nxt = current
    section = num.times.map { nxt = nxt.nxt }

    CircularList.stitch(current, section.last.nxt)
    CircularList.stitch(section.last, section.first)

    section.first
  end

  def insert(new_head, at:)
    old_tail = new_head.prev
    old_tip = at.nxt

    CircularList.stitch(at, new_head)
    CircularList.stitch(old_tail, old_tip)

    current
  end

  def self.stitch(one, another)
    one.nxt = another
    another.prev = one
  end
end
