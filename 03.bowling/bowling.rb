#!/usr/bin/ruby

require 'debug' 

score = ARGV[0].split(",")

score.map! { |n| n == "X" ? Integer(10) : Integer(n)  }

frame_cnt = 1
nageta_cnt = 0
nageta_total_cnt = 0
score_total = 0

for i in score
    score_total += i
    if frame_cnt < 10
        # ストライク
        if nageta_cnt == 0 && i > 9
            score_total += score[nageta_total_cnt + 1]
            score_total += score[nageta_total_cnt + 2]
            nageta_cnt = 0
            frame_cnt += 1
        # 1投目
        elsif nageta_cnt == 0
            nageta_cnt += 1
        # 2投目
        else 
            # スペア
            if score[nageta_total_cnt - 1] + i > 9
                score_total += score[nageta_total_cnt + 1]
            end

            nageta_cnt = 0
            frame_cnt += 1
        end

        nageta_total_cnt += 1

    else
        # 10フレーム以降は足すだけ
    end
end

puts score_total
