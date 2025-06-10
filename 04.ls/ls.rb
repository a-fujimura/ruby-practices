#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

COL_COUNT = 3

def main
  show_all = false
  show_reverse = false

  opt = OptionParser.new
  opt.on('-a') do |option|
    show_all = option
  end

  opt.on('-r') do |option|
    show_reverse = option
  end
  opt.parse!

  flags = show_all ? File::FNM_DOTMATCH : 0
  filenames_array = Dir.glob('*', flags)
  filenames_array.reverse! if show_reverse

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
