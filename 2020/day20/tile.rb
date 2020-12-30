# frozen_string_literal: true

require 'ostruct'

class Tile
  class << self
    def all
      @all ||= []
    end
    alias tiles all

    def find(id)
      all.find { _1.id.to_s == id.to_s }
    end

    def corners
      all.select { _1.unmatched_borders.length == 2 }
    end
  end

  attr_accessor :id, :pxls, :unmatched_borders

  def to_s
    pxls.map { _1.join('') }.join("\n")
  end

  def inspect
    to_s
  end

  def initialize(id, pxls)
    @id = id
    @pxls = pxls.map { _1.split('') }
    @unmatched_borders = borders.each_pair.map(&:last)

    Tile.tiles << self
  end

  def unmatched_directions
    borders.each_pair.select { |_k, v| unmatched_borders.include? v }.map(&:first)
  end

  def borders
    OpenStruct.new top: pxls[0], right: pxls.map(&:last), bottom: pxls[size - 1], left: pxls.map(&:first)
  end

  def find_neighbor(direction)
    border = borders.send direction.to_sym

    matches = (Tile.all - [self]).select do |cell|
      borders = cell.borders.each_pair.map(&:last)
      borders.include?(border) || borders.include?(border.reverse)
    end

    raise "Found duplicate matches for #{id}'s #{direction} border" if matches.count > 1

    matches.first
  end

  # Clockwise
  def rotate
    self.pxls = pxls.transpose.map(&:reverse)
  end

  def rotate_counter
    self.pxls = pxls.map(&:reverse).transpose
  end

  def flipx
    self.pxls = pxls.map(&:reverse)
  end

  def flipy
    self.pxls = pxls.map(&:reverse).transpose.map(&:reverse).transpose.map(&:reverse)
  end

  private

  def size
    pxls.size
  end
end
