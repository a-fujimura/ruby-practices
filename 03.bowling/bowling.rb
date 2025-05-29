#!/usr/bin/ruby
# frozen_string_literal: true

scores = ARGV[0].split(",")

scores = scores.map { |n| n == "X" ? 10 : n.to_i }

frame_count = 1
throw_count = 0
throw_total_count = 0
total_score = 0

scores.each do |score|
  total_score += score
  next unless frame_count < 10

  # ストライク
  if throw_count.zero? && score == 10
    total_score += scores[throw_total_count + 1]
    total_score += scores[throw_total_count + 2]
    throw_count = 0
    frame_count += 1
    # 1投目
  elsif throw_count.zero?
    throw_count += 1
    # 2投目
  else
    # スペア
    total_score += scores[throw_total_count + 1] if scores[throw_total_count - 1] + score == 10

    throw_count = 0
    frame_count += 1
  end

  throw_total_count += 1
end

puts total_score
