# frozen_string_literal: true

require_relative 'runner'
require_relative 'syntax_iterator'

# Load input
input = File.read(File.expand_path('input.txt', __dir__))
lines = input.split("\n").map(&:strip)

SyntaxIterator.new(lines).permute
