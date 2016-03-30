function AlgConnectivity(L::Symmetric;vecs=false)
    # Calculates the algebraic connectivity of graph with laplacian L
    # Input: L a symmetric laplacian matrix
    # Output: value of algebraic connectivity λ_2
    e_vals = eigfact(L,2:2)
    λ = e_vals.values[1]
    ν = e_vals.vectors[1]
    if vecs
        return λ, ν
    else
        return λ
    end
end
function AlgConnectivity(L::Array{Float64,2},vecs=false)
    Ls = Symmetric(L)
    results = AlgConnectivity(Ls,vecs=vecs)
    return results
end

function AlgConnectivity(L::SparseMatrixCSC;vecs=false)
    # Calculates the algebraic connectivity of graph with laplacian L
    # Input: L a symmetric laplacian matrix
    # Output: value of algebraic connectivity λ_2
    s = svds(L,nsv=size(L)[1]-1)
    if length(s[2]) < size(L)[1]
        # there are some zero eigen values that weren't calculated
        λ = s[2][end]
    else
        λ = s[2][end-1]
    end

    if vecs
        ν = s[1][:,end-1]
        return λ, ν
    else
        return λ
    end
end
