# frozen_string_literal: true

input = File.open(File.expand_path('input', __dir__)).readlines

ords = { 'forward' => 1, 'down' => 1i, 'up' => -1i }
input.join.scan(/(\w+).(\d+)/).map { |d, amt| ords[d] * amt.to_i }.sum.tap { p _1.real * _1.imag }
