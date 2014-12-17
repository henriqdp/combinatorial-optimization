class Graphmatch::MinimalVertexCover
  def initialize(maximal_matching, zero_weighted_graph)
    


    @minimal_cover = []
    left = zero_weighted_graph.keys
    puts maximal_matching.inspect
    unmatched_vertices = left - maximal_matching.keys
    puts unmatched_vertices.inspect
    right_all = []
    right_matched = []
    zero_weighted_graph.each_pair do |key, value|
      value.each_pair do |k, v|
        right_all << k
      end
    end
    maximal_matching.each_pair do |key,value|
        right_matched << value
    end
    right_all = right_all & right_all

    #puts right_all.inspect
    #puts right_matched.inspect

    right_unmatched = (right_all & right_all) - (right_matched & right_matched)
    puts right_unmatched.inspect

  end

  def minimal_vertex_cover
    @minimal_cover
  end
end
