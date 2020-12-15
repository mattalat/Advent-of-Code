# frozen_string_literal: true

require_relative '../advent'

class SeatMap
  COMBS = [-1, 0, 1].permutation(2).to_a.push([1, 1]).push([-1, -1]).freeze

  attr_accessor :sm, :row_count, :col_count

  def initialize(raw)
    @sm = raw.map { |row| row.split('') }
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
      around >= 4 ? 'L' : '#'
    else
      sm[r][c]
    end
  end

  def neighbors_occupied(r, c)
    neighbors_to_check(r, c).map { |cell| sm[cell[0]][cell[1]] }
                            .map { |cell| cell == '#' ? 1 : 0 }
                            .sum
  end

  def neighbors_to_check(r, c)
    COMBS.dup
         .map { |coords| [r + coords[0], c + coords[1]] }
         .reject { |cell| cell.any?(&:negative?) || cell[0] >= row_count || cell[1] >= col_count }
  end
end

raw = Advent.load_input_into_array
sm = SeatMap.new(raw)

old_state = ''

until old_state == sm.to_s
  old_state = sm.to_s
  sm.tick
end

puts sm.occupied_seats
