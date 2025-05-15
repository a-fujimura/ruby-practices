#!/usr/bin/env ruby

require 'date'
require 'optparse'

def show_wday(day)
    wday_list = ["月","火","水","木","金","土","日"]
    return wday_list[day]
end

def show_calendar(year,month)
    date = Date.new(year,month,-1)
    if date.month < 10
        puts "     #{date.month}月 #{date.year}年"
    else
        puts "    #{date.month}月 #{date.year}年"
    end
    puts "日 月 火 水 木 金 土"
    print "   " * (Date.new(year,month,1).wday)

    for i in 1..date.day
        wday = Date.new(year,month,i).wday
        if i < 10
            print " #{i} "
        else
            print "#{i} "
        end
        if wday == 6
            puts ""
        end
    end
end

today = DateTime.now

if ARGV.length > 0
    params = ARGV.getopts("y:","m:")
    if(params["y"] == nil)
        show_calendar(today.year,Integer(params["m"]))
    else
        show_calendar(Integer(params["y"]),Integer(params["m"]))
    end
else
    show_calendar(today.year,today.month)
end