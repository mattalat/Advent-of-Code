# frozen_string_literal: true

class SyntaxIterator
  attr_reader :lines

  def self.swap_nop_and_jmp(instruction)
    if instruction.match?('jmp')
      instruction.gsub('jmp', 'nop')
    else
      instruction.gsub('nop', 'jmp')
    end
  end

  def initialize(lines)
    @lines = lines
  end

  # For each nop or jmp instruction, swap them and execute the new script.
  # Print the output if the program resolves.
  def permute
    lines.each_with_index do |instr, i|
      next unless instr.match?(/(nop|jmp)/i)

      output = Runner.execute(lines.clone.tap { |arr| arr[i] = SyntaxIterator.swap_nop_and_jmp(instr) })
      puts output unless output.match?(/INFINITE/)
    end
  end
end
