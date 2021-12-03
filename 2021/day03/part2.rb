# frozen_string_literal: true

input = File.open(File.expand_path('input', __dir__)).readlines.map(&:chomp)

def col_tally_sort(arr, preferred)
  meth = preferred == '1' ? :max_by : :min_by
  cols = arr.map { _1.split('') }.transpose
  cols.map(&:tally).map { _1['0'] == _1['1'] ? preferred : _1.send(meth, &:last).first }
end

o_candidates = input.dup
(0..input[0].length).each do |i|
  t = col_tally_sort(o_candidates, '1')
  o_candidates.select! { _1[i] == t[i] }
  break if o_candidates.length == 1
end

c_candidates = input.dup
(0..input[0].length).each do |i|
  t = col_tally_sort(c_candidates, '0')
  c_candidates.select! { _1[i] == t[i] }
  break if c_candidates.length == 1
end

p o_candidates.first.to_i(2) * c_candidates.first.to_i(2)
