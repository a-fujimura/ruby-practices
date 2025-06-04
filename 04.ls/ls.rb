#!/usr/bin/env ruby
# frozen_string_literal: true

COL_COUNT = 3

def main
  filenames_array = Dir.glob('*')
  return unless filenames_array.length.positive?

  length_max = filenames_array.max_by(&:length).length
  filenames_matrix = convert_filenames_matrix(filenames_array, COL_COUNT)
  print_filenames_matrix(filenames_matrix, length_max)
end

def convert_filenames_matrix(filenames_array, col_count)
  row_count = filenames_array.length.ceildiv(col_count)

  filenames_matrix = filenames_array.each_slice(row_count).map do |slice|
    slice.fill('', slice.size...row_count)
  end
  filenames_matrix.transpose
end

def print_filenames_matrix(filenames_matrix, length_max)
  filenames_matrix.each do |filenames|
    print filenames.map { |filename| filename.ljust(length_max) }.join("\t")
    puts
  end
end

main
