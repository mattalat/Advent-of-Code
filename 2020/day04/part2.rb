# frozen_string_literal: true

require_relative 'passport'

# Load input
input = File.read(File.expand_path('input.txt', __dir__))
lines = input.split("\n").push('') # put a final empty el for coda

# Gather attribute string array and create Passports
passports = []
dict_string = ''

lines.each do |line|
  if line.empty?
    passports << Passport.build_from_dictionary_string(dict_string)
    dict_string = ''
  else
    dict_string += line + ' '
  end
end

# Print count of valid Passports
puts passports.filter(&:valid?).count
