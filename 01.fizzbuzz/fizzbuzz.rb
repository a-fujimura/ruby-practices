# frozen_string_literal: true

20.times do |i|
  counter = i + 1
  if (counter % 3).zero? && (counter % 5).zero?
    puts 'FizzBuzz'
  elsif (counter % 3).zero?
    puts 'Fizz'
  elsif (counter % 5).zero?
    puts 'Buzz'
  else
    puts counter
  end
end
