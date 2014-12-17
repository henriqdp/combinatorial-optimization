require 'set'

class Graphmatch::MinimalVertexCover


  def initialize(maximal_matching, zero_weighted_graph)
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
        end
      end
    end

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

    edges_to_be_analyzed = Array.new
    z_set = Array.new
    (0..39).each do |i|
      if matched[i] == false
        edges_to_be_analyzed << [i,false]
        z_set << i
      end
    end
    
    matched_or_not = false
    visited = Array.new(40, false)
    
    while(edges_to_be_analyzed.size > 0)
      edges[edges_to_be_analyzed[0][0]].each do |edge|
        if edge[1] == edges_to_be_analyzed[0][1] && !visited[edges_to_be_analyzed[0][0]]
          z_set << edge[0]
          edges_to_be_analyzed << [edge[0], !edges_to_be_analyzed[0][1]]
          visited[edges_to_be_analyzed[0][0]] == true
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
