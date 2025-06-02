#!/usr/bin/env ruby
# frozen_string_literal: true
COL_COUNT = 3

def main
  files = Dir.glob("*")
  if files.length > 0
    filenames_matrix = convert_matrix(files, COL_COUNT)
    print_matrix(filenames_matrix)
  end
end

def convert_matrix(array, col_count)
  length_max = array.max_by(&:length).length
  row_count = array.length.ceildiv(col_count)

  matrix = array.each_slice(row_count).map do |slice|
    slice.fill("", slice.size...row_count)
  end
  return matrix.transpose
end

def print_matrix(matrix_data)
  (0...matrix_data.length).each do |i|
    print matrix_data[i].join("\t")
    puts
  end
end

main
