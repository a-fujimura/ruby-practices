#!/usr/bin/env ruby
# frozen_string_literal: true

require "date"
require "optparse"

def main
  today = Date.today
  params = ARGV.getopts("y:", "m:")
  year = params["y"].nil? ? today.year : params["y"].to_i
  month = params["m"].nil? ? today.month : params["m"].to_i

  show_calendar(year, month)
end

def show_calendar(year, month)
  first_date = Date.new(year, month, 1)
  last_date = Date.new(year, month, -1)

  puts "#{first_date.month}月 #{first_date.year}年".rjust(14)

  puts "日 月 火 水 木 金 土"
  print "   " * first_date.wday

  (first_date..last_date).each do |date|
    print "#{date.day.to_s.rjust(2)} "
    puts "" if date.saturday?
  end

  puts "" unless last_date.saturday?
end

main
