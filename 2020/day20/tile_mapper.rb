# frozen_string_literal: true

require_relative 'tile'

class TileMapper
  attr_accessor :atlas

  def initialize(area)
    size = Math.sqrt(area).to_i
    @atlas = []
    size.times { @atlas << Array.new(size, 0) }
  end

  def print_atlas(str = atlas_string)
    str.chars.each_slice((Tile.all.first.pxls.size - 2) * @atlas.size) { puts _1.join }
  end

  def atlas_string
    strs = []

    atlas.each do |row|
      row_lines = []

      row.each do |id|
        Tile.find(id).pxls[1..-2].map { |c| c[1..-2] }.each_with_index do |line, i|
          row_lines[i] ||= []
          row_lines[i] << line.join
        end
      end

      strs << row_lines.join
    end

    strs.join
  end

  def tiles
    Tile.tiles
  end

  def match
    tiles.each do |tile|
      next if tile.unmatched_borders.empty?

      tile.unmatched_borders.each do |b|
        (unmatched - [tile]).each do |potential|
          match_border(b, potential, tile) ? break : next
        end
      end
    end
  end

  def unmatched
    tiles.select { _1.unmatched_borders.any? }
  end

  def match_border(border, potential, tile)
    good_match = potential.unmatched_borders.find { |nb| nb == border || nb == border.reverse }
    return false unless good_match

    potential.unmatched_borders -= [good_match]
    tile.unmatched_borders -= [border] - [border.reverse]
  end
end
