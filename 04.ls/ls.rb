#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'shellwords'
require 'etc'

PERMISSION_LIST = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx'].freeze
FILETYPE_LIST = {
  'blockSpecial'     => 'b',
  'characterSpecial' => 'c',
  'directory'        => 'd',
  'link'             => 'l',
  'socket'           => 's',
  'fifo'             => 'p',
  'file'             => '-'
}
COL_COUNT = 3

def main
  show_all = false
  show_reverse = false
  show_longformat = false

  opt = OptionParser.new
  opt.on('-a') { |option| show_all = option }
  opt.on('-r') { |option| show_reverse = option }
  opt.on('-l') { |option| show_longformat = option }
  opt.parse!

  flags = show_all ? File::FNM_DOTMATCH : 0
  filenames_array = Dir.glob('*', flags)
  filenames_array.reverse! if show_reverse

  if show_longformat
    print_filenames_array(filenames_array)
  else
    print_filenames_matrix(filenames_array, COL_COUNT)
  end
end

def convert_filenames_matrix(filenames_array, col_count)
  row_count = filenames_array.length.ceildiv(col_count)
  filenames_matrix = filenames_array.each_slice(row_count).map do |slice|
    slice.fill('', slice.size...row_count)
  end
  filenames_matrix.transpose
end

def print_filenames_matrix(filenames_array, col_count)
  return unless filenames_array.length.positive?

  max_filename_length = filenames_array.max_by(&:length).length
  filenames_matrix = convert_filenames_matrix(filenames_array, col_count)
  filenames_matrix.each do |filenames|
    print filenames.map { |filename| filename.ljust(max_filename_length) }.join("\t")
    puts
  end
end

def print_filenames_array(filenames_array)
  total = filenames_array.map { |filename| File.stat(filename).blocks }.sum
  puts "total #{total}"
  return unless filenames_array.length.positive?

  hardlink_max = filenames_array.map { |filename| File.stat(filename).nlink.to_s.length }.max
  filesize_max = filenames_array.map { |filename| File.stat(filename).size.to_s.length }.max

  filenames_array.each do |filename|
    next unless filename.length.positive?

    puts convert_filename_longformat(filename, hardlink_max, filesize_max)
  end
end

def convert_filename_longformat(filename, hardlink_max, filesize_max)
  file_stat = File.stat(filename)
  file_type = FILETYPE_LIST[file_stat.ftype]
  file_permission = file_stat.mode & 0o777
  user_permission  = PERMISSION_LIST[(file_permission / 0o100) % 0o10]
  group_permission = PERMISSION_LIST[(file_permission / 0o10)  % 0o10]
  other_permission = PERMISSION_LIST[file_permission % 0o10]

  convert_filename = "#{file_type}#{user_permission}#{group_permission}#{other_permission} "
  convert_filename += "#{file_stat.nlink.to_s.rjust(hardlink_max)} "
  convert_filename += "#{Etc.getpwuid(file_stat.uid).name}  "
  convert_filename += "#{Etc.getgrgid(file_stat.gid).name}  "
  convert_filename += "#{file_stat.size.to_s.rjust(filesize_max)} "
  convert_filename += "#{file_stat.mtime.strftime('%_m')} "
  convert_filename += "#{file_stat.mtime.strftime('%_d')} "
  convert_filename += "#{file_stat.mtime.strftime('%H:%M')} "
  convert_filename += filename.to_s

  convert_filename
end

main
