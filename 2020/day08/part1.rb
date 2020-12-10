# frozen_string_literal: true

require_relative 'runner'

# Load input
input = File.read(File.expand_path('input.txt', __dir__))
lines = input.split("\n").map(&:strip)

puts Runner.execute(lines)
