#!/usr/bin/env ruby
# frozen_string_literal: true

files = Dir.glob("*")
length_max = files.max_by(&:length).length
COL_COUNT = 3
row_count = files.length.ceildiv(COL_COUNT)
filenames_matrix = Array.new(COL_COUNT) { Array.new(row_count, "") }

item_count = 0

(0..filenames_matrix.length - 1).each do |i|
  (0..filenames_matrix[0].length - 1).each do |j|
    view_str = files[item_count].to_s
    view_str = view_str.ljust(length_max)
    item_count += 1

    filenames_matrix[i][j] = view_str
  end
end

filenames_matrix = filenames_matrix.transpose

(0..filenames_matrix.length - 1).each do |i|
  print filenames_matrix[i].join("\t")
  puts
end
