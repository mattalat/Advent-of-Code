# frozen_string_literal: true

require_relative '../advent'
require_relative 'game'

input = Advent.read.join

player1, player2 = input.split("\n\n").map { _1.split("\n")[1..].map(&:to_i) }

# Part 1

game = Game.new(player1, player2)
game.play
puts Game.score game.winner

# Part 2

game = Game.new(player1, player2, recursive: true)
game.play
puts Game.score game.winner
