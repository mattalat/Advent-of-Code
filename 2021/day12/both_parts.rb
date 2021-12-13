# frozen_string_literal: true

input = File.open(File.expand_path('input', __dir__)).readlines.map(&:chomp)

class Graph
  attr_accessor :edges

  def initialize
    @edges = Hash.new { |h, k| h[k] = [].clone }
  end

  def add_edge(node, other)
    edges[node] << other
    edges[other] << node
  end

  def double_paths_between(start = 'start', last = 'end')
    paths = [*path_between(start, last)]
    small_caves = edges.keys.select { _1.downcase == _1 } - %w[start end]

    small_caves.each do |other|
      @double_node = other
      paths.push(*paths_between(start, last))
    end

    paths.uniq
  end

  def paths_between(start = 'start', last = 'end')
    @all_paths = []
    @path = []
    @visited = []
    @double_node ||= nil
    path_between(start, last)
    @all_paths
  end

  private

  def path_between(start, last)
    @visited << start if start.downcase == start
    @path << start

    if start == last
      @all_paths << @path.dup
    else
      edges[start].each do |other|
        next if @visited.grep(/^#{other}$/).count == (@double_node == other ? 2 : 1)

        path_between(other, last)
      end
    end

    @path.pop
    i = @visited.index(start)
    @visited.slice!(i) unless i.nil?
  end
end

connections = input.map { _1.split('-') }

graph = Graph.new

connections.each do |node, other|
  graph.add_edge(node, other)
end

p graph.paths_between.length
p graph.double_paths_between.length
