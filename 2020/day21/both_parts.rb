# frozen_string_literal: true

require_relative '../advent'

input = Advent.read

foods = input.map do |line|
  { ingredients: line.split('(')[0].scan(/\w+/), allergens: line.scan(/(?<=, )\w+|(?<=contains )\w+/) }
end

all_ingredients = foods.map{ _1[:ingredients] }.flatten.uniq
all_allergens = foods.map { _1[:allergens] }.flatten.uniq

unknown_allergens = all_allergens.map do |a|
  possibilities = foods.select { _1[:allergens].include? a }.map { _1[:ingredients] }.reduce { _1 & _2 }
  [a, possibilities]
end

known_allergens = []

until unknown_allergens.empty?
  new_known = unknown_allergens.find { _1[1].length == 1 }
  unknown_allergens -= [new_known]
  unknown_allergens.map { _1[1] -= new_known[1] }
  known_allergens << new_known
end

good_ingredients = all_ingredients - known_allergens.map { |k| k[1][0] }

puts foods.map { _1[:ingredients].intersection(good_ingredients).count }.sum
puts known_allergens.sort_by { _1[0] }.map { _1[1][0] }.join(',')
