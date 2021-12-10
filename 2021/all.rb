# frozen_string_literal: true

require 'benchmark'
require 'terminal-table'
require 'tty-command'
require 'tty-logger'
require 'tty-progressbar'

log = TTY::Logger.new
bar = TTY::ProgressBar.new('Running [:bar]', total: Dir['day*'].count)
cmd = TTY::Command.new(printer: :null)

rows = Dir['day*'].sort.map do |day|
  bar.advance
  files = Dir["#{day}/*.rb"].grep(/(part\d|both_parts)\.rb/)
  running_time = Benchmark.realtime { files.each { cmd.run('ruby', _1) } }
  [day.scan(/\d+/).first.gsub(/^0/, ''), format('%<time>.3f', time: running_time).gsub(/^0+/, '')]
end

table = Terminal::Table.new headings: ['Day', 'Time (s)'], rows: rows
table.align_column(0, :right)
table.align_column(1, :right)
puts "\n#{table}\n\n"

log.success 'Total', format('%<sum>0.2f', sum: rows.map(&:last).map(&:to_f).sum), 's'
