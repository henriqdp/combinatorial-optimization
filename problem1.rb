require './matching/maxmatch.rb'
require './matching/minimalcover.rb'

$PROBLEM_SIZE = 0

def find_minimum_vertex_cover matching, edges
  minimal_cover = Graphmatch::MinimalVertexCover.new matching, edges
  return minimal_cover.minimal_vertex_cover
end

def find_zero_weighted_edges(cost_matrix)
  edges = Hash.new
  (0..$PROBLEM_SIZE-1).each do |person|
    (0..$PROBLEM_SIZE-1).each do |committee|
      edges[person] = Hash.new if edges[person].nil?
      if cost_matrix[person][committee] == 0
        edges[person]["committee#{committee}".to_sym] = 0
      end
    end
  end
  return edges
end

def perfect_matching? matching
  return matching.size == $PROBLEM_SIZE
end

def hungarian_algorithm adjacency_matrix
  edges = find_zero_weighted_edges(adjacency_matrix)
  left  = Array(0..$PROBLEM_SIZE-1)
  right = Array(0..$PROBLEM_SIZE-1)

  matching = Graphmatch.match(left, right
  .collect{|c| c = "committee#{c}".to_sym}, Marshal.load(Marshal.dump(edges)))
  until perfect_matching? matching


    vertex_cover = find_minimum_vertex_cover matching, edges
    min = 99
    (0..$PROBLEM_SIZE - 1).each do |i|
      (0..$PROBLEM_SIZE - 1).each do |j|
        if(adjacency_matrix[i][j] < min \
           && vertex_cover.index(i).nil? \
           && vertex_cover.index(j+20).nil?)
          min = adjacency_matrix[i][j]
        end
      end
    end

    (0..$PROBLEM_SIZE - 1).each do |i|
      (0..$PROBLEM_SIZE - 1).each do |j|
        if(vertex_cover.index(i).nil? && vertex_cover.index(j+20).nil?)
          adjacency_matrix[i][j] -= min
        elsif(!vertex_cover.index(i).nil? && !vertex_cover.index(j+20).nil?)
          adjacency_matrix[i][j] += min
        end
      end
    end

    edges = find_zero_weighted_edges(adjacency_matrix)
    left  = Array(0..$PROBLEM_SIZE-1)
    right = Array(0..$PROBLEM_SIZE-1)
    matching = Graphmatch.match(left, right
    .collect{|c| c = "committee#{c}".to_sym}, Marshal.load(Marshal.dump(edges)))

  end
  return matching
end

#
#
# MAIN PROGRAM
#
#

#First, an array has to be created to store the preferences of every person
preferences = Array.new

#opens the input file in reading mode
File.open('chair.txt', 'r') do |file|

  #extracts the raw text and splits it by line,
  #then splits every line by the space character
  preferences = file.read.split("\n").collect{|line| line = line.split(' ')}

  #removes every first character from the arrays (so "C12" becomes "12" f. ex.)
  #it will help turning them into numbers later
  preferences = preferences.collect{|line| line = line
  .collect{|committee| committee = committee[1..-1]}}

  #since the array index can be easily used instead of the chairman number,
  #the latter becomes useless, so it can just be dropped
  preferences.collect!{|person| person.drop(1)}

  #finally, convert everything into numbers
  preferences = preferences.collect{|line| line = line
  .collect{|committee| committee = committee.to_i}}

  #the final result is an array of length 20 consisting of small arrays
  #of length 3 containing the ordered preferences of every person
end

$PROBLEM_SIZE = preferences.length

#creates a weight matrix where every element can be 0, 1, 2 or 99
cost_matrix = Array.new(20)
cost_matrix.collect!{|line| line = Array.new(20).collect{|c| c = 99}}

#brings the values from the preferences matrix to the cost matrix
(0..preferences.length-1).each do |person|
  cost_matrix[person][preferences[person][0]-1] = 0
  cost_matrix[person][preferences[person][1]-1] = 1
  cost_matrix[person][preferences[person][2]-1] = 2
end


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

result = hungarian_algorithm(cost_matrix)
File.open('result', 'w') do |file|
  result.each_pair do |k, v|
    file.printf "Person %2d is assigned to the committee %2d. ",
    k + 1, v.to_s[9..-1].to_i + 1
    file.puts "His preferences were, in order, #{preferences[k].inspect}"
  end
end
