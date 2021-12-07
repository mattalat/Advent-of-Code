# frozen_string_literal: true

input = File.open(File.expand_path('input', __dir__)).readlines.map(&:chomp).join(',')

school = input.split(',').map(&:to_i).tally
school.default = 0

simulate_a_day = proc {
  school.transform_keys!(&:pred)
  new_fish = school.delete(-1) || 0
  school[6] += new_fish
  school[8] += new_fish
}

80.times(&simulate_a_day).then { puts school.values.sum }
(256 - 80).times(&simulate_a_day).then { puts school.values.sum }
