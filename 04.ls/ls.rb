#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'shellwords'
require 'etc'

PERMISSION_LIST = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx'].freeze
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

  return unless filenames_array.length.positive?

  length_max = filenames_array.max_by(&:length).length
  filenames_matrix = convert_filenames_matrix(filenames_array, COL_COUNT)

  if show_longformat
    print_filenames_array(filenames_array)
  else
    print_filenames_matrix(filenames_matrix, length_max)
  end
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

def print_filenames_array(filenames_array)
  hardlink_max = filenames_array.map { |filename| File.stat(filename).nlink.to_s.length }.max
  filesize_max = filenames_array.map { |filename| File.stat(filename).size.to_s.length }.max
  filenames_array.each do |filename|
    next unless filename.length.positive?

    file_stat = File.stat(filename)
    file_type = file_stat.ftype == 'file' ? '-' : 'd'
    permission = file_stat.mode & 0o777
    user_perm  = PERMISSION_LIST[(permission / 0o100) % 0o10]
    group_perm = PERMISSION_LIST[(permission / 0o10)  % 0o10]
    other_perm = PERMISSION_LIST[permission % 0o10]
    xattr_option = `xattr -l #{Shellwords.escape(filename)}`.length.positive? ? '@' : ' '

    filename_info = "#{file_type}#{user_perm}#{group_perm}#{other_perm}#{xattr_option} "
    filename_info += "#{file_stat.nlink.to_s.rjust(hardlink_max)} "
    filename_info += "#{Etc.getpwuid(file_stat.uid).name}  "
    filename_info += "#{Etc.getgrgid(file_stat.gid).name}  "
    filename_info += "#{file_stat.size.to_s.rjust(filesize_max)} "
    filename_info += "#{file_stat.mtime.strftime('%_m')} "
    filename_info += "#{file_stat.mtime.strftime('%_d')} "
    filename_info += "#{file_stat.mtime.strftime('%H:%M')} "
    filename_info += filename.to_s
    puts filename_info
  end
end

main
