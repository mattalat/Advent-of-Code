# frozen_string_literal: true

class Game
  def self.deck_to_i(deck)
    deck.each_with_index.map { |x, idx| x * (deck.length - idx) }.sum
  end

  attr_accessor :player1, :player2, :seen, :winner

  def initialize(player1, player2, recursive: false)
    @player1 = player1.dup
    @player2 = player2.dup
    @recursive = recursive
    @seen = []
    @winner = nil
  end

  def play
    play_round until we_have_a_winner?

    (player1.empty? ? :player2 : :player1).tap { |winners_name| self.winner = send(winners_name) }
  end

  def to_str
    "#{player1.join}|#{player2.join}"
  end

  private

  def we_have_a_winner?
    player1.empty? || player2.empty? || (@recursive && seen.include?(to_str))
  end

  def play_round
    seen.push to_str

    c1 = player1.shift
    c2 = player2.shift

    if @recursive && c1 <= player1.length && c2 <= player2.length
      fight_recursively(c1, c2)
    else
      fight_normally(c1, c2)
    end
  end

  def fight_recursively(card1, card2)
    recursive_game = Game.new(player1[0...card1], player2[0...card2], recursive: true)
    recursive_game.play == :player1 ? player1.push(card1, card2) : player2.push(card2, card1)
  end

  def fight_normally(card1, card2)
    card1 > card2 ? player1.push(card1, card2) : player2.push(card2, card1)
  end
end
