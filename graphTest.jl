using Graphs
n = 10
k = 2
beta = 0.3
svt.S
g = watts_strogatz_graph(n, k, beta)
lap = Symmetric(laplacian_matrix(g))
laps = Symmetric(laplacian_matrix_sparse(g))
lapsp = laplacian_matrix_sparse(g)
function algConnectivity(L::Symmetric;vecs=false)
    # Calculates the algebraic connectivity of graph with laplacian L
    # Input: L a symmetric laplacian matrix
    # Output: value of algebraic connectivity λ_2
    e_vals = eigfact(L,2:2)
    λ = e_vals.values
    ν = e_vals.vectors
    if vecs
        return λ, ν
    else
        return λ
    end
end
function algConnectivity(L::SparseMatrixCSC;vecs=false)
    # Calculates the algebraic connectivity of graph with laplacian L
    # Input: L a symmetric laplacian matrix
    s = svds(L)
    # Output: value of algebraic connectivity λ_2
    λ = s[2][end-1]
    ν = s[1][:,end-1]
    if vecs
        return λ, ν
    else
        return λ
    end
end
@time connectivity = algConnectivity(lapsp,vecs=false)
println(size(lap))
println(typeof(lap))
plot(g)
issym(laps)
laps.data[3,1] = 90
laps.uplo
s = svds(lapsp)
s[1]
sv = svd(full(lapsp))
svt = svdfact(full(lapsp))
