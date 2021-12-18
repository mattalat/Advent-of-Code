# frozen_string_literal: true

input = File.open(File.expand_path('input', __dir__)).readlines.map(&:chomp)

class Graph
  attr_accessor :edges, :new_edges, :trip

  def initialize(connection_strings)
    @edges = Hash.new { |h, k| h[k] = [].clone }
    connections = connection_strings.map { _1.split('-') }
    connections.each { |node, other| add_edge(node, other) }

    # Starting cave cannot be reentered
    @edges.each_key { |node| @edges[node] -= ['start'] }

    transform_caves!

    # Trip ends when ending cave is reached
    edges.delete(trip[1])
  end

  def add_edge(node, other)
    edges[node] << other
    edges[other] << node
  end

  def visitable_small_caves
    edges.keys.select { _1 < 10 } - trip
  end

  # Assuming there are fewer than 10 small caves, use integers [0..9] to signify
  # small caves and [10..] to signify large caves. This drastically improves
  # hash access.
  def transform_caves!
    sm = 0
    bg = 10

    transform_map = edges.keys.map { [_1] * 2 }.to_h.transform_values do |old_cave|
      old_cave.downcase == old_cave ? sm += 1 : bg += 1
    end

    self.trip = [transform_map['start'], transform_map['end']]
    self.edges = edges.map { |k, v| [transform_map[k], v.map { transform_map[_1] }] }.to_h
  end
end

class Solver
  attr_reader :graph

  def initialize(graph)
    @graph = graph
  end

  def single_paths
    @double_node = nil
    complete_paths
  end

  def single_and_double_paths
    graph.visitable_small_caves.flat_map do |other|
      @double_node = other
      complete_paths
    end.uniq
  end

  private

  def complete_paths
    @all_paths = []
    @path = []
    @visited = []
    paths_to_end(graph.trip[0])
    @all_paths
  end

  def visited?(node)
    @visited.select { _1 == node }.count == (@double_node == node ? 2 : 1)
  end

  def paths_to_end(start)
    @visited << start if start < 10
    @path << start

    if start == graph.trip[1]
      @all_paths << @path.dup
    else
      graph.edges[start].each { |other| paths_to_end(other) unless visited?(other) }
    end

    @path.pop
    @visited.slice!(@visited.index(start)) if @visited.include?(start)
  end
end

graph = Graph.new(input)
solver = Solver.new(graph)

p solver.single_paths.length
p solver.single_and_double_paths.length
