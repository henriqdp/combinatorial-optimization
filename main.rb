#First of all, an array has to be created to store the preferences of every person
preferences = Array.new

#opens the input file in reading mode
File.open('chair.txt', 'r') do |file|

  #extracts the raw text and splits it by line, then splits every line by the space character
  preferences = file.read.split("\n").collect{|line| line = line.split(' ')}

  #removes every first character from the arrays (so "C12" becomes "12", for instance). it will help turning them into numbers later
  preferences = preferences.collect{|line| line = line.collect{|committee| committee = committee[1..-1]}}

  #since the array index can be easily used instead of the chairman number, the latter becomes useless, so it can just be dropped
  preferences.collect!{|person| person.drop(1)}

  #finally, convert everything into numbers
  preferences = preferences.collect{|line| line = line.collect{|committee| committee = committee.to_i}}

  #the final result is an array of length 20 consisting of small arrays of length 3 containing the ordered preferences of every person
end

puts preferences.inspect
