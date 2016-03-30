using Graphs

function MaxLambda2inEV(e::Int,v::Int)
    # finds the graph with maximum algebraic connectivity given v vertices and e edges
    # Input: Integer e number of edges, integer v number of vertices
    # Output: The value of maximum lambda and the graph object

    @assert v>=1
    if e > v^v
        # Check the number of edges
        error("Too many edges")
    end
    possible_edges = collect(combinations(collect([1:v]),2))
    possible_graphs = combinations(possible_edges,e)
    tot = length(possible_graphs)
    iter = 1
    λ_max = typemin(Float64)
    max_g = SimpleAdjacencyList
    for i in possible_graphs

        if mod(iter,25000) == 0
            # print progress
            @printf("processing graph %d/%d\n",iter,tot)
        end
        g = simple_adjlist(v,is_directed=false)
        for j in i
            add_edge!(g, j[1], j[2])   # add edge
        end

        laplacian = Symmetric(laplacian_matrix(g))
        eigs = eigvals(laplacian,v-1:v)

        e_vals = eigfact(L2,2:2)
        λ = e_vals.values
        ν = e_vals.vectors
        if λ > λ_max
            max_g = g
            λ_max = λ
        end
        iter += 1
    end
    return (λ_max, max_g)
end

#
# num_v = 3
# num_e = 8
#
# (λ_max, max_g) = MaxLambda2inEV(num_e,num_v)
#
# println(max_g)
