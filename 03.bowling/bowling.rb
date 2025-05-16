#!/usr/bin/ruby
# frozen_string_literal: true

require 'debug'

score = ARGV[0].split(',')

score.map! { |n| n == 'X' ? Integer(10) : Integer(n) }

frame_cnt = 1
nageta_cnt = 0
nageta_total_cnt = 0
score_total = 0

score.each do |i|
  score_total += i
  next unless frame_cnt < 10

  # ストライク
  if nageta_cnt.zero? && i > 9
    score_total += score[nageta_total_cnt + 1]
    score_total += score[nageta_total_cnt + 2]
    nageta_cnt = 0
    frame_cnt += 1
  # 1投目
  elsif nageta_cnt.zero?
    nageta_cnt += 1
  # 2投目
  else
    # スペア
    score_total += score[nageta_total_cnt + 1] if score[nageta_total_cnt - 1] + i > 9

    nageta_cnt = 0
    frame_cnt += 1
  end

  nageta_total_cnt += 1
end

puts score_total
