# frozen_string_literal: true

module Advent
  module_function

  def load_input_into_array(filename: 'input.txt', caller_loc: caller_locations)
    called_from = File.dirname(caller_loc.first.path)
    File.open(File.join(called_from, filename)).readlines
  end

  def read(caller_loc: caller_locations)
    load_input_into_array caller_loc: caller_loc
  end
end
