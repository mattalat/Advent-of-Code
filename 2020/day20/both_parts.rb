# frozen_string_literal: true

require_relative '../advent'
require_relative 'tile'
require_relative 'tile_mapper'

# This whole thing is bad

input = Advent.read.map(&:strip).reject { _1.empty? }

input.each_slice(11) do |slice|
  id = slice[0].scan(/\d+/)[0]
  pxls = slice[1..]
  Tile.new(id, pxls)
end

tm = TileMapper.new(Tile.all.count)
tm.match

puts "Part 1: sum of corner IDs #{Tile.corners.map(&:id).flatten.map(&:to_i).reduce(&:*)}"

# Plug in top left corner as origin (other corners' positions cannot be guaranteed)
# NOTE: found by calling #unmatched_directions on each corner and plucking.
tm.atlas[0][0] = 1847

(0...tm.atlas.size).each do |row|
  # Find first square based on the cell above it
  if tm.atlas[row][0].zero?
    prev = Tile.find(tm.atlas[row - 1][0])
    bord = prev.borders.bottom
    cand = prev.find_neighbor(:bottom)

    raise 'No candidate found' unless cand

    if bord == cand.borders.top
      nil
    elsif bord == cand.borders.bottom
      cand.flipy
    elsif bord == cand.borders.right
      cand.rotate_counter
    elsif bord == cand.borders.left
      cand.flipy
      cand.rotate
    elsif bord.reverse == cand.borders.top
      cand.flipx
    elsif bord.reverse == cand.borders.right
      cand.flipy
      cand.rotate_counter
    elsif bord.reverse == cand.borders.bottom
      cand.flipx
      cand.flipy
    elsif bord.reverse == cand.borders.left
      cand.rotate
    end

    raise 'Mismatch' unless cand.borders.top == prev.borders.bottom

    tm.atlas[row][0] = cand.id.to_i
  end

  # For the rest of the row, find each square's neighbor to the right
  tm.atlas[row].each_with_index do |cell, i|
    next unless cell.zero?

    prev = Tile.find(tm.atlas[row][i - 1])
    bord = prev.borders.right
    cand = prev.find_neighbor(:right)

    raise 'No candidate found' unless cand

    if bord == cand.borders.top
      cand.flipx
      cand.rotate_counter
    elsif bord == cand.borders.bottom
      cand.rotate
    elsif bord == cand.borders.right
      cand.flipx
    elsif bord == cand.borders.left
      nil
    elsif bord.reverse == cand.borders.top
      cand.rotate_counter
    elsif bord.reverse == cand.borders.right
      cand.flipy
      cand.flipx
    elsif bord.reverse == cand.borders.bottom
      cand.flipx
      cand.rotate
    elsif bord.reverse == cand.borders.left
      cand.flipy
    end

    raise 'Mismatch' unless cand.borders.left == prev.borders.right

    tm.atlas[row][i] = cand.id.to_i
  end
end

sea_monster = ['                  # ',
               '#    ##    ##    ###',
               ' #  #  #  #  #  #   '].map { _1.tr(' ', '.') }.map(&:chars)
monster_regex = sea_monster.map(&:join).join('.{76}')

# NOTE: found by hand
corrected_atlas = tm.atlas_string.chars.each_slice(8 * 12).to_a.transpose.map(&:join).join

# Find the starting index for each dragon pattern
dragons = []
imatch = -1
while corrected_atlas.match?(/#{monster_regex}/, imatch + 1)
  imatch = corrected_atlas.index(/#{monster_regex}/, imatch + 1)
  dragons << imatch
end

# For each starting position, mark the pixels corresponding to
# dragons with 'O' so they won't be tallied
atlas_pixels = corrected_atlas.chars
dragons.each do |idragon|
  sea_monster.map(&:join).join('.' * 76).chars.each_with_index do |c, i|
    raise if c == '#' && atlas_pixels[i + idragon] != '#'

    atlas_pixels[i + idragon] = 'O' if c == '#'
  end
end

puts "Part 2: choppiness of #{atlas_pixels.tally['#']}"
