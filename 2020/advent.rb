# frozen_string_literal: true

module Advent
  module_function

  def load_input_into_array(input_filename = 'input.txt')
    called_from = File.dirname(caller_locations.first.path)
    File.read(File.join(called_from, input_filename)).split.map(&:strip)
  end
end
