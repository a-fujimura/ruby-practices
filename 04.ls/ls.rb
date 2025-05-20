#!/usr/bin/env ruby
files = Dir.glob("#{Dir.pwd}/*")
length_max = (files.max_by { |word| word.length }).sub("#{Dir.pwd}/","").length
row_cnt = 0
for i in files
    view_str = i.sub("#{Dir.pwd}/","")
    if view_str.length < length_max
        view_str += " "*(length_max - view_str.length)
    end

    print "#{view_str}\t"

    row_cnt += 1
    if row_cnt > 2 
        puts ""
        row_cnt = 0
    end
end

