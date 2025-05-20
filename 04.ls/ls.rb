#!/usr/bin/env ruby
# frozen_string_literal: true

files = Dir.glob("#{Dir.pwd}/*")
length_max = files.max_by(&:length).sub("#{Dir.pwd}/", '').length
col_cnt = 3
row_cnt = files.length / col_cnt

row_cnt += 1 if (files.length % 3).positive?
rslt_list = Array.new(col_cnt) { Array.new(row_cnt, '') }

item_cnt = 0

(0..rslt_list.length - 1).each do |i|
  (0..rslt_list[0].length - 1).each do |j|
    view_str = if files[item_cnt].nil?
                 ''
               else
                 files[item_cnt].sub("#{Dir.pwd}/", '')
               end

    view_str += ' ' * (length_max - view_str.length) if view_str.length < length_max
    item_cnt += 1

    rslt_list[i][j] = view_str
  end
end

rslt_list = rslt_list.transpose

(0..rslt_list.length - 1).each do |i|
  (0..rslt_list[0].length - 1).each do |j|
    print "#{rslt_list[i][j]}\t"
  end
  puts ''
end
