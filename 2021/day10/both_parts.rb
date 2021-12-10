# frozen_string_literal: true

input = File.open(File.expand_path('input', __dir__)).readlines.map(&:chomp)

match = {
  ')' => '(',
  ']' => '[',
  '}' => '{',
  '>' => '<'
}
imatch = match.invert

scores = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25_137
}

chunks = input.map(&:chars)
corruptions = []
good = []

chunks.each do |chunk|
  stack = []

  invalid_tokens = chunk.map do |token|
    if imatch.keys.include? token
      stack.push(token) and nil
    else
      token unless match[token] == stack.pop
    end
  end

  invalid_tokens.all?(&:nil?) ? good.push(chunk) : corruptions.push(invalid_tokens.compact.first)
end

p corruptions.map { scores[_1] }.sum

completion_scores = good.map do |chunk|
  stack = []
  chunk.each { |token| imatch.keys.include?(token) ? stack.push(token) : stack.pop }
  stack.map { imatch[_1] }.reverse.inject(0) { |acc, token| (acc * 5) + (match.keys.index(token) + 1) }
end

p completion_scores.sort[completion_scores.length / 2]
