# frozen_string_literal: true

require 'active_model'

class Passport
  include ActiveModel::Validations

  attr_reader :original_string
  attr_accessor :byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid, :cid

  validates :byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid, presence: true
  validates :byr, inclusion: { in: '1920'..'2002' }
  validates :iyr, inclusion: { in: '2010'..'2020' }
  validates :eyr, inclusion: { in: '2020'..'2030' }
  validates :hcl, format: { with: /\A#[0-9a-f]{6}\Z/ }
  validates :ecl, inclusion: { in: %w[amb blu brn gry grn hzl oth] }
  validates :pid, format: { with: /\A[0-9]{9}\Z/ }
  validates :hgt, format: { with: /(in|cm)\Z/ }
  validates :numerical_hgt, inclusion: { in: 150..193 }, if: ->(p) { p.hgt && p.hgt[-2..-1] == 'cm' }
  validates :numerical_hgt, inclusion: { in: 59..76 }, if: ->(p) { p.hgt && p.hgt[-2..-1] == 'in' }

  def initialize(attr_string_array)
    @original_string = attr_string_array
    attr_string_array.map { |kv| { kv.split(':')[0] => kv.split(':')[1] } }
                     .reduce({}) { |acc, el| acc.merge(el) }
                     .each { |k, v| send("#{k}=", v) }
  end

  def numerical_hgt
    return -1 unless hgt

    hgt[0..-3].to_i
  end
end

# Load input
input = File.read(File.expand_path('input.txt', __dir__))
lines = input.split("\n").push('') # put a final empty el for coda

# Gather attribute string array and create Passports
passports = []
attribute_array = []

lines.each do |line|
  if line.empty?
    passports << Passport.new(attribute_array.flatten)
    attribute_array = []
  else
    attribute_array << line.split(' ')
  end
end

# Print count of valid Passports
puts passports.filter(&:valid?).count
