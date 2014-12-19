class Graphmatch::MinimalVertexCover


  def initialize(maximal_matching, zero_weighted_graph)
    
    #transforms the hash into an array
    #every person has a number from 0 to 19
    #every committee has a number from 20 to 39
    #the array is a list of adjacencies with 'true'
    #for the edges that belong to the minimal matching
    #and false to those that do not
    edges = Array.new
    (0..39).each do |i|
      edges[i] = Array.new
    end

    maximal_matching.each_pair do |key,value|
      edges[key] << [value.to_s[9..-1].to_i + 20, true]
      edges[value.to_s[9..-1].to_i + 20] << [key, true]
    end

    zero_weighted_graph.each_pair do |key, value|
      value.each_pair do |k, v|
        if(edges[key].index([k.to_s[9..-1].to_i + 20, true]).nil?)
          edges[key] << [k.to_s[9..-1].to_i + 20, false]
          edges[k.to_s[9..-1].to_i + 20] << [key, false]
        end
      end
    end

    #looks for uncovered (unmatched) vertices
    matched = Array.new(40, false)
    (0..39).each do |i|
      if(edges[i] != [])
        edges[i].each do |edge|
          if(edge[1] == true)
            matched[i] = true
          end
        end
      end
    end

    #edges_to_be_analyzed = uncovered vertices
    edges_to_be_analyzed = Array.new
    (0..39).each do |i|
      if matched[i] == false
        edges_to_be_analyzed << [i,true]
      end
    end

    #keeps track of the analysed vertices
    visited = Array.new(40, false)

    mincover = Array.new
    delete = Array.new

    #vertices reached by no edges are automatically 
    #added to the minimal cover
    edges_to_be_analyzed.each do |edge|
      if edges[edge[0]] == []
        mincover << edge[0]
        visited[edge[0]] = true
        delete << edge
      end
    end
    delete.each do |e|
      edges_to_be_analyzed.delete(e)
    end


  #walks through alternating paths adding
  #nodes to the minimal cover
   while edges_to_be_analyzed.size > 0
      edge = edges_to_be_analyzed.shift
      visited[edge[0]] = true
      if edge[1] == true 
        edges[edge[0]].each do |connected_edge|
          if connected_edge[1] == false
            mincover << connected_edge[0]
            edges_to_be_analyzed << connected_edge
          end
        end
      elsif edge[1] == false
        edges[edge[0]].each do |connected_edge|
          if connected_edge[1] == true
            edges_to_be_analyzed << connected_edge
          end
        end
      end
   end


#adds the nodes that do not belong to 
#alternating paths to the minimal cover
    (0..19).each do |person|
      edges[person].each do |v|
        if v[1] == true && visited[person] == false
          mincover << person
        end
      end
    end

    mincover &= mincover
    @minimal_cover = mincover
  end

  def minimal_vertex_cover
    @minimal_cover
  end
end
