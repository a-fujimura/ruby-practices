#!/usr/bin/env ruby
# frozen_string_literal: true

require "date"
require "optparse"

def show_calendar(year, month)
  first_date = Date.new(year, month, 1)
  last_date = Date.new(year, month, -1)
  if first_date.month < 10
    puts "     #{first_date.month}月 #{first_date.year}年"
  else
    puts "    #{first_date.month}月 #{first_date.year}年"
  end
  puts "日 月 火 水 木 金 土"
  print "   " * Date.new(year, month, 1).wday

  (first_date..last_date).each do |date|
    print "#{date.day.to_s.rjust(2)} "
    puts "" if date.saturday?
  end

  unless last_date.saturday?
    puts "" # ターミナルの終端出力(%)を出力しないための改行
  end
end

today = Date.today
params = ARGV.getopts("y:", "m:")
year = params["y"].nil? ? today.year : params["y"].to_i
month = params["m"].nil? ? today.month : params["m"].to_i

show_calendar(year, month)
