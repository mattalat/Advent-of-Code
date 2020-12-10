# frozen_string_literal: true

class Runner
  attr_accessor :accumulator, :line, :instructions, :visited_lines

  def self.execute(instructions)
    new(instructions).run_from_pointer
  end

  def initialize(instructions)
    @instructions = instructions
    @accumulator = 0
    @line = 0
    @visited_lines = []
  end

  def run_from_pointer
    return "INFINITE LOOP: #{accumulator}" if visited_lines.include? line
    return "L#{line}, acc: #{accumulator}" if line >= instructions.length

    visited_lines << line
    execute_instruction
  end

  private

  def execute_instruction
    instr, amt = instructions[line].split(' ')
    send(instr.to_sym, amt.to_i)
    run_from_pointer
  end

  def nop(*)
    self.line += 1
  end

  def jmp(amt)
    self.line += amt
  end

  def acc(amt)
    self.accumulator += amt
    self.line += 1
  end
end
