using Graphs

function DisconnectedEdges(A::Symmetric)
    n = size(L)[1]
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

function AlgCentrality(L::Symmetric;vecs=false)
    # Calculates the algebraic centrality of graph with laplacian L
    # Input: L a symmetric laplacian matrix
    # Output: value of algebraic centrality λ_2
    e_vals = eigfact(L,2:2)
    λ = e_vals.values
    ν = e_vals.vectors
    if vecs
        return λ, ν
    else
        return λ
    end
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

function addEdge(L::Symmetric,e::Tuple,dis::Array)
    #add edge to laplacian matrix
    #Input: Laplacian matrix L, and edge e
    #Output: New Laplacian and modified disconnected edge list
    c = maximum(e)
    r = minimum(e)
    Lnew = L
    Lnew.data[r,c] = -1 # hack until Julia has direct support
    Lnew.data[r,r] = Lnew.data[r,r] + 1 # add to the degree
    Lnew.data[c,c] = Lnew.data[c,c] + 1 # add to the degree
    deleteat!(dis,findin(dis,[e]))
    return Lnew,dis
end

# Create a symmetric matrix that is based on the upper triangle (:U)
# L = Symmetric([4 -1 -1 -1 -1; -1 1 0 0 0; -1 0 2 0 -1; -1 0 0 2 -1; -1 0 -1 -1 3],:U)
L = Symmetric(zeros(50,50))

disconnectedEdges = DisconnectedEdges(L)
# println(disconnectedEdges)
while length(disconnectedEdges) > 50#!isempty(disconnectedEdges)
    num = length(disconnectedEdges)
    if mod(num,1000) == 0
        println(num)
    end
    centrality = AlgCentrality(L,vecs=true)
    greedyEdge = SelectGreedyEdge(centrality[2],disconnectedEdges)
    newLaplacian = addEdge(L,greedyEdge,disconnectedEdges)
    L = newLaplacian[1]
    disconnectedEdges = newLaplacian[2]
end
# println(L)
# println(disconnectedEdges)
println("done")
