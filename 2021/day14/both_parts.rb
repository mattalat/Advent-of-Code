# frozen_string_literal: true

input = File.open(File.expand_path('input', __dir__)).readlines.map(&:chomp)

template = input[0].chars
rules = input[2..].map { _1.split(' -> ') }.to_h

DOWNBEAT = template.first
CODA     = template.last

tally = Hash.new(0)
template.each_cons(2).map(&:join).each { |pair| tally[pair] += 1 }

spawns = rules.map { |k, v| [k, ["#{k[0]}#{v}", "#{v}#{k[1]}"]] }.to_h
atoms  = rules.map(&:first).flat_map(&:chars).uniq

grow = proc {
  new_tally = Hash.new(0)

  tally.each do |pair, count|
    spawns[pair].each { |resulting_pair| new_tally[resulting_pair] += count }
  end

  tally = new_tally
}

def sorted_atom_counts(atoms, tally)
  atom_counts = atoms.map do |atom|
    count = tally.select { |pair, _| pair.match? atom }
                 .sum { |pair, occ| pair == "#{atom}#{atom}" ? occ : occ / 2 }
    [atom, count]
  end.to_h

  atom_counts[DOWNBEAT] += 1
  atom_counts[CODA] += 1

  atom_counts.map(&:last).sort
end

10.times(&grow)

sorted_counts = sorted_atom_counts(atoms, tally)
p sorted_counts.last - sorted_counts.first

30.times(&grow)

sorted_counts = sorted_atom_counts(atoms, tally)
p sorted_counts.last - sorted_counts.first
