#!/usr/bin/env ruby
# frozen_string_literal: true

COL_COUNT = 3

def main
  files = Dir.glob('*')
  return unless files.length.positive?

  length_max = files.max_by(&:length).length
  filenames_matrix = convert_matrix(files, COL_COUNT)
  print_matrix(filenames_matrix, length_max)
end

def convert_matrix(array, col_count)
  row_count = array.length.ceildiv(col_count)

  matrix = array.each_slice(row_count).map do |slice|
    slice.fill('', slice.size...row_count)
  end
  matrix.transpose
end

def print_matrix(matrix, length_max)
  (0...matrix.length).each do |i|
    matrix[i].map! { |element| element.ljust(length_max) }
    print matrix[i].join("\t")
    puts
  end
end

main
