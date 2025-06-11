#!/usr/bin/ruby
# frozen_string_literal: true

def main
  scores = ARGV[0].split(',')
  game = Game.new(scores)
  game.score
end

class Shot
  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end

  def score
    return 10 if mark == 'X'

    mark.to_i
  end
end

class Frame
  attr_reader :first_shot, :second_shot, :third_shot, :first_next, :second_next

  def initialize(first_mark, second_mark, third_mark, first_next, second_next)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
    @first_next = Shot.new(first_next)
    @second_next = Shot.new(second_next)
  end

  def score
    score = @first_shot.score + @second_shot.score + @third_shot.score

    if @first_shot.score == 10
      score += @first_next.score + @second_next.score
    elsif @first_shot.score + @second_shot.score == 10
      score += @first_next.score
    end

    score
  end
end

class Game
  attr_reader :frames

  def initialize(scores)
    @frames = []
    throw_count = 0
    (0...9).each do |_frame_count|
      if scores[throw_count] == 'X'
        # ストライクの時
        frames << Frame.new(10, 0, 0, scores[throw_count + 1], scores[throw_count + 2])
        throw_count += 1
      else
        # 2回投げる時
        frames << Frame.new(scores[throw_count], scores[throw_count + 1], 0, scores[throw_count + 2], 0)
        throw_count += 2
      end
    end
    first_shot = scores[throw_count] == 'X' ? 10 : scores[throw_count]
    second_shot = scores[throw_count + 1] == 'X' ? 10 : scores[throw_count + 1]
    third_shot = scores[throw_count + 2] == 'X' ? 10 : scores[throw_count + 2]
    frames << Frame.new(first_shot, second_shot, third_shot, 0, 0)
  end

  def score
    total_score = 0
    @frames.each do |frame|
      total_score += frame.score
      frame.score
    end
    puts total_score
  end
end

main
