# frozen_string_literal: true

# Shunting-yard algorithm implementation
# Adapted from psuedocode on https://en.wikipedia.org/wiki/Shunting-yard_algorithm

class Parsely
  PRECEDENCE = {
    '+' => 1,
    '-' => 1,
    '*' => 1,
    '/' => 1,
    '(' => 0,
    ')' => 0
  }.freeze

  class << self
    # Sugar
    def parse(expression)
      new(expression).parse
    end

    # Evaluate am expression by converting infix to postfix (if necessary) and evaluating the postfix
    #
    # @param parsed_expression [String|Array] expression to parse, either postfix Array or infix string
    def evaluate(parsed_expression)
      parsed_expression = parse(parsed_expression) unless parsed_expression.is_a? Array

      parsed_expression.each_with_object([]) do |o, result|
        case o
        when /\d+/ then result.push(o)
        when %r{[+,-,*,/]}
          operands = result.pop(2)
          calc = operands.map(&:to_i).reduce(&o.to_sym)
          result.push(calc)
        end
      end.first
    end
  end

  attr_accessor :tokens, :output, :operators, :precedence

  def initialize(expression)
    @tokens = expression.scan(%r{\d+|[+,-,*,(,),/]})
    @output = []
    @operators = []
    @precedence = PRECEDENCE.dup
  end

  # Converts an arithmetic string from infix notation to an equivalent postfix/reverse Polish notation array
  def parse
    handle_token(tokens.shift) until tokens.empty?
    output.push(*operators.reverse)
  end

  private

  def handle_token(token)
    case token
    when /\d/ then output.push token
    when %r{[+,-,*,/]}
      output.push operators.pop while operators_poppable?(token)
      operators.push token
    when /\(/ then operators.push token
    when /\)/ then pop_till_you_drop
    end
  end

  def pop_till_you_drop
    while (topop = operators.pop) != '('
      output.push topop
    end
  end

  def operators_poppable?(token)
    operators.any? && operators.last != '(' && precedence[operators.last] >= precedence[token]
  end
end
