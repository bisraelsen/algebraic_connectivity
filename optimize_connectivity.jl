include("random_rewire.jl")
include("utilities.jl")
include("algConnectivity.jl")

using PyPlot

function Paccept(c,c_prime,T,its)
    if c_prime >= c
        return 1
    else
        return exp(-its)/exp(-1)
    end
end

n = 100
e = 4*n

g = simple_NE_graph(n,e)
Graphs.plot(g)
# g = erdos_renyi_graph(g,n,b,has_self_loops=false)
# plot_to_file(g,"original")
write_to_file(g,"original")
current_state = deepcopy(g)
tot_its = 50000
edge_change_prob = 0.75
T = 1
c = AlgConnectivity(laplacian_matrix_sparse(current_state))
# c = AlgConnectivity(laplacian_matrix(current_state))
@printf("Original connectivity: %.3f\n",c)
c_hist = zeros(tot_its,1)
for i = 1:tot_its
    c_hist[i] = c
    if mod(i,10000) == 0
        @printf("iteration %d\n",i)
    end
    # if c > 0 && edge_change_prob > 0.06
    #     println("connected")
    #     edge_change_prob = 1/e
    # end
    candidate = rewire(deepcopy(current_state),edge_change_prob)
    c_prime = AlgConnectivity(laplacian_matrix(candidate))
    # c_prime = AlgConnectivity(laplacian_matrix(candidate))
    # @printf("Paccept: %0.3f\n",Paccept(c,c_prime,T))
    accept_p = Paccept(c,c_prime,T,tot_its)
    if rand() < accept_p
        # better, lets move there
        c = c_prime
        current_state = deepcopy(candidate)
    # elseif rand() < p
    #     # worse but we still moved there
    #     c = c_prime
    #     current_state = deepcopy(candidate)
    else
        # reject rate
        # p += 0.001
        continue
    end
end
@printf("Final connectivity: %.3f\n",c)
# plot_to_file(current_state,@sprintf("rewire%d",1))
write_to_file(current_state,"opt")
Graphs.plot(current_state)

println(size(c_hist))
PyPlot.plot(collect(1:tot_its),c_hist)
