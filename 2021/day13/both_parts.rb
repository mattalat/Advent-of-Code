# frozen_string_literal: true

input = File.open(File.expand_path('input', __dir__)).readlines.map(&:chomp)

coords = input.grep(/\d+,\d+/)
              .map { _1.split(',').map(&:to_i) }

# Store fold instructions as [Boolean, Integer] where the first argument
# is `true` if the fold is on the x-axis.
folds = input.grep(/fold along/)
             .map { _1.match(/fold along ([x,y]=\d+)/)[1] }
             .map { _1.split('=') }
             .map { |d, amt| [d == 'x', amt.to_i] }

def reflect(value, amt)
  value >= amt ? (amt - (value % amt)) - 1 : value
end

def fold_coords(coords, fold)
  dx, amt = fold
  coords = coords.map(&:dup)

  coords.select { |x, y| dx ? x > amt : y > amt }.each { _1[dx ? 0 : 1] -= 1 }
  coords.map { |x, y| dx ? [reflect(x, amt), y] : [x, reflect(y, amt)] }.uniq
end

def translate(coords)
  height = coords.max_by(&:last).last
  width = coords.max_by(&:first).first

  (0..height).map do |y|
    (0..width).map do |x|
      coords.include?([x, y]) ? '#' : ' '
    end.join
  end
end

puts fold_coords(coords, folds.first).length

message = folds.reduce(coords, &method(:fold_coords))

puts ''
puts translate(message)
