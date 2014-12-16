require './matching/maxmatch.rb'

def find_vertex_cover adjacency_matrix
  return []
end

def find_maximum_matching adjacency_matrix
  return []
end


def perfect_matching? adjacency_matrix
  if matching == []
    false
  else
    true
  end
end



def hungarian_algorithm adjacency_matrix
  matching = []
  until perfect_matching? adjacency_matrix, matching
    vertex_cover = find_vertex_cover adjacency_matrix
    fir
    matching = find_maximum_matching adjacency_matrix
  end
  return matching
end




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

#creates a weight matrix where every element can be 0, 1, 2 or 99
cost_matrix = Array.new(20)
cost_matrix.collect!{|line| line = Array.new(20).collect{|c| c = 99}}

#brings the values from the preferences matrix to the cost matrix
(0..preferences.length-1).each do |person|
  cost_matrix[person][preferences[person][0]-1] = 0
  cost_matrix[person][preferences[person][1]-1] = 1
  cost_matrix[person][preferences[person][2]-1] = 2
end

=begin
#row minima is already subtracted, so let's subtract the col minima
(0..19).each do |i|
  min = 99
  (0..19).each do |j|
    min = cost_matrix[j][i] if(cost_matrix[j][i] < min)
  end
  (0..19).each do |j|
    cost_matrix[j][i] = cost_matrix[j][i] - min
  end
end
=end



#hungarian_algorithm(cost_matrix)
