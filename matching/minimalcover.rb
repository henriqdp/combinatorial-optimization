class Graphmatch::MinimalVertexCover


  def initialize(maximal_matching, zero_weighted_graph)
    
    #transforms the hash into an array
    #every person has a number from 0 to 19
    #every committee has a number from 20 to 39
    edges = Array.new
    (0..39).each do |i|
      edges[i] = Array.new
    end

    #puts zero_weighted_graph.inspect

    maximal_matching.each_pair do |key,value|
      edges[key] << [value.to_s[9..-1].to_i + 20, true]
      edges[value.to_s[9..-1].to_i + 20] << [key, true]
    end

    zero_weighted_graph.each_pair do |key, value|
      value.each_pair do |k, v|
        if(edges[key].index([k.to_s[9..-1].to_i + 20, true]).nil?)
          edges[key] << [k.to_s[9..-1].to_i + 20, false]
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
    z_set = Array.new
    (0..39).each do |i|
      if matched[i] == false
        edges_to_be_analyzed << [i,false]
        z_set << i
      end
    end

    #keeps track of the analysed vertices
    visited = Array.new(40, false)

    #puts edges.inspect
    puts edges_to_be_analyzed.inspect

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
    edges.each_with_index do |edge, i|
      print "#{i} == >"
      puts edge.inspect
    end
    puts edges_to_be_analyzed.inspect
    puts mincover.inspect
    gets

    while edges_to_be_analyzed.size > 0
      current = edges_to_be_analyzed[0][0]
    end
    

    while(edges_to_be_analyzed.size > 0)
      edges[edges_to_be_analyzed[0][0]].each do |edge|
        if edge[1] == edges_to_be_analyzed[0][1] && !visited[edges_to_be_analyzed[0][0]]
          z_set << edge[0]
          edges_to_be_analyzed << [edge[0], !edges_to_be_analyzed[0][1]]
          visited[edges_to_be_analyzed[0][0]] = true
        end
      end

      edges_to_be_analyzed = edges_to_be_analyzed[1..-1]
      matched_or_not = !matched_or_not
    end

    @edges = edges
    @minimal_cover = (Array(0..19) - z_set) + (Array(20..39) & z_set)
  end

  def minimal_vertex_cover
    @minimal_cover
  end
end
