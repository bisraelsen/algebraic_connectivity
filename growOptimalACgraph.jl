using SimpleGraphs
include("algConnectivity.jl")

function DisconnectedEdges(A::Symmetric)
    n = size(A)[1]
    dis = Array(Tuple{Int,Int},0)
    for i = 1:n
        for j = i+1:n
            if A[i,j] == 0
                dis = cat(1,dis,(i,j))
            end
        end
    end
    return dis
end

function SelectGreedyEdge(e::Array,dis::Array)
    # Select the edge that will increase the algebraic centrality the most
    # Input: eigenvector associated with λ_2
    # Output: index where edge should be added
    improv_max = typemin(Float64)
    choice = Tuple{Int,Int}
    for edge in dis
        improv = (e[edge[1]]-e[edge[2]])^2
        x = improv > improv_max
        if improv > improv_max
            improv_max = improv
            choice = edge
        end
    end
    return choice
end

function addEdge!(g::SimpleGraphs.SimpleGraph,e::Tuple,dis::Array)
    # add edge to graph, and delete edge from disconnectedEdges list
    c = maximum(e)
    r = minimum(e)
    add!(g,c,r)
    deleteat!(dis,findin(dis,[e]))
end

function growOptimalA(n,e;prog=false)
    n = 100
    edg = 3*n
    g = RandomTree(n)
    A = Symmetric(adjacency(g))
    disconnectedEdges = DisconnectedEdges(A)
    for i=1:(edg-n+1)
        if mod(i,500) == 0 && prog
            println(i)
        end
        centrality = AlgConnectivity(g,false,vecs=true)
        greedyEdge = SelectGreedyEdge(centrality[2],disconnectedEdges)
        addEdge!(g,greedyEdge,disconnectedEdges)
    end
    c = AlgConnectivity(g,false)
    return g,c
end
