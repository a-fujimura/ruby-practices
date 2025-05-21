#!/usr/bin/env ruby
# frozen_string_literal: true

require "date"
require "optparse"

def show_calendar(year, month)
  date = Date.new(year, month, -1)
  if date.month < 10
    puts "     #{date.month}月 #{date.year}年"
  else
    puts "    #{date.month}月 #{date.year}年"
  end
  puts "日 月 火 水 木 金 土"
  print "   " * Date.new(year, month, 1).wday

  (1..date.day).each do |i|
    if i < 10
      puts " #{i} "
    else
      puts "#{i} "
    end
    puts "" if Date.new(year, month, i).saturday?
  end
end

today = Time.now

if ARGV.length.positive?
  params = ARGV.getopts("y:", "m:")
  if params["y"].nil?
    show_calendar(today.year, Integer(params["m"]))
  else
    show_calendar(Integer(params["y"]), Integer(params["m"]))
  end
else
  show_calendar(today.year, today.month)
end
