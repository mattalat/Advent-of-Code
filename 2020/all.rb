# frozen_string_literal: true

require 'benchmark'
require 'terminal-table'

rows = Dir['day*'].sort.map do |day|
  files = Dir["#{day}/*.rb"].select { _1.match?(/(part\d|both_parts)\.rb/) }

  print "\rRunning #{day}"
  running_time = Benchmark.realtime { files.each { |file| `ruby #{file}` } }

  [day.scan(/\d+/).first, format('%.3f', running_time).gsub(/^0+/, '')]
end

puts ''
puts "Done.\n\n"

table = Terminal::Table.new headings: ['Day', 'Time (s)'], rows: rows
table.align_column(1, :right)

puts table
puts "\nTotal running time: #{format('%0.2f', rows.map(&:last).map(&:to_f).sum)} s"
