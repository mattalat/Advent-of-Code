# frozen_string_literal: true
require 'byebug'

input = File.open(File.expand_path('input', __dir__)).readlines.map(&:chomp)

class Packet
  attr_reader :version, :type
  attr_accessor :value, :contents, :subpackets

  def initialize(message)
    @version    = message[0...3].to_i(2)
    @type       = message[3...6].to_i(2)
    @contents   = message[6..]
    @subpackets = []
  end

  def parse
    if type == 4
      @value = convert_literal
    else
      perform_operation
    end
  end

  def value
    return @value if @value

    sub_values = subpackets.map(&:value)

    case type
    when 0 then sub_values.sum
    when 1 then sub_values.reduce(:*)
    when 2 then sub_values.min
    when 3 then sub_values.max
    when 5 then sub_values.first > sub_values.last ? 1 : 0
    when 6 then sub_values.first < sub_values.last ? 1 : 0
    when 7 then sub_values.first == sub_values.last ? 1 : 0
    end
  end

  def collapse
    [self, subpackets.map(&:collapse)].flatten
  end

  private

  def convert_literal
    num = []
    num << contents.slice!(0...4) while contents.slice!(0) == '1'
    num << contents.slice!(0...4) # the last 4 bits consitute the end of the number
    num.join.to_i(2)
  end

  def perform_operation
    operand_type = contents.slice!(0).to_i
    operand_type.zero? ? operation_zero : operation_one
  end

  def operation_zero
    subpacket_length = contents.slice!(0...15).to_i(2)
    subpackets_contents = contents.slice!(0...subpacket_length)

    while subpackets_contents.include? '1'
      subpackets << Packet.new(subpackets_contents)
      subpackets.last.parse
      subpackets_contents = subpackets.last.contents
    end
  end

  def operation_one
    subpacket_count = contents.slice!(0...11).to_i(2)
    num_read = 0

    while num_read < subpacket_count
      subpackets << Packet.new(contents)
      subpackets.last.parse
      self.contents = subpackets.last.contents
      num_read += 1
    end
  end
end

segments = input[0].chars.map { _1.to_i(16).to_s(2) }
message  = segments.map { _1.rjust(4, '0') }.join

packet = Packet.new(message)
packet.parse

p packet.collapse.map(&:version).sum
p packet.value
