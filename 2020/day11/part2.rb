# frozen_string_literal: true

require_relative '../advent'

class SeatMap
  COMBS = [-1, 0, 1].permutation(2).to_a.push([1, 1]).push([-1, -1]).freeze

  attr_accessor :sm, :row_count, :col_count

  def initialize(raw_rows)
    @sm = raw_rows.map { |row| row.split('') }
    @row_count = @sm.length
    @col_count = @sm.first.length
  end

  def to_s
    sm.map(&:join).join("\n")
  end

  def tick
    new_sm = Array.new(row_count).map { Array.new(col_count) }
    (0...row_count).each do |i|
      (0...col_count).each do |j|
        new_sm[i][j] = next_state(i, j)
      end
    end

    self.sm = new_sm
  end

  def occupied_seats
    sm.map { |row| row.select { |cell| cell == '#' }.count }.sum
  end

  private

  def next_state(r, c)
    around = neighbors_occupied(r, c)
    case sm[r][c]
    when 'L'
      around.zero? ? '#' : 'L'
    when '#'
      around >= 5 ? 'L' : '#'
    else
      sm[r][c]
    end
  end

  def neighbors_occupied(r, c)
    COMBS.map { |vec| first_along_vector(vec, r, c) }
         .sum { |cell| cell == '#' ? 1 : 0 }
  end

  def first_along_vector(vec, r, c)
    next_coords = [r + vec[0], c + vec[1]]

    until next_coords.any?(&:negative?) || next_coords[0] >= row_count || next_coords[1] >= col_count
      space = sm[next_coords[0]][next_coords[1]]
      return space unless space == '.'

      next_coords = [next_coords[0] + vec[0], next_coords[1] + vec[1]]
    end

    'L'
  end
end

sm = SeatMap.new(Advent.load_input_into_array)

old_state = ''

until old_state == sm.to_s
  old_state = sm.to_s
  sm.tick
end

puts sm.occupied_seats
