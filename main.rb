#First of all, an array has to be created to store the preferences of every person
preferences = Array.new
File.open('chair.txt', 'r') do |file|

  #extracts the raw text and splits it by line, then splits every line by the space character
  preferences = file.read.split("\n").collect!{|line| line = line.split(' ')}
end

puts preferences.inspect
