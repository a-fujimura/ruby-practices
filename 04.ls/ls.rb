#!/usr/bin/env ruby
# frozen_string_literal: true

files = Dir.glob("*")
length_max = files.max_by(&:length).length
COL_COUNT = 3
row_count = files.length.ceildiv(COL_COUNT)
result_list = Array.new(COL_COUNT) { Array.new(row_count, "") }

item_count = 0

(0..result_list.length - 1).each do |i|
  (0..result_list[0].length - 1).each do |j|
    view_str = files[item_count].to_s
    view_str = view_str.ljust(length_max)
    item_count += 1

    result_list[i][j] = view_str
  end
end

result_list = result_list.transpose

(0..result_list.length - 1).each do |i|
  print result_list[i].join("\t")
  puts
end
