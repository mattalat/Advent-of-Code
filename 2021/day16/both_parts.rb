# frozen_string_literal: true
require 'byebug'

input = File.open(File.expand_path('input', __dir__)).readlines.map(&:chomp)

segments = input[0].chars.map { _1.to_i(16).to_s(2) }
message  = segments.map { _1.rjust(4, '0') }.join

class Packet
  attr_reader :version, :type
  attr_accessor :value, :contents, :subpackets

  def initialize(message)
    message     = message.dup
    @version    = message[0...3].to_i(2)
    @type       = message[3...6].to_i(2)
    @contents   = message[6..]
    @subpackets = []
  end

  def parse
    if type == 4
      @value = parse_literal
    else
      parse_operator
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

  def parse_literal
    num = []
    group = '1'

    while group[0] == '1'
      group = contents.slice!(0...5)
      num << group[1..]
    end

    num.join.to_i(2)
  end

  def parse_operator
    length_type = contents.slice!(0).to_i
    length_type.zero? ? parse_operator_zero : parse_operator_one
  end

  def parse_operator_zero
    subpacket_length = contents.slice!(0...15).to_i(2)
    subpackets_contents = contents.slice!(0...subpacket_length)

    while subpackets_contents.include? '1'
      subpackets << Packet.new(subpackets_contents)
      subpackets.last.parse
      subpackets_contents = subpackets.last.contents
    end
  end

  def parse_operator_one
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

packet = Packet.new(message)
packet.parse

p packet.collapse.map(&:version).sum
p packet.value
