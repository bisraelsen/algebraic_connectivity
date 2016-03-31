include("random_rewire.jl")
include("utilities.jl")
include("algConnectivity.jl")
include("arg_config.jl")
using PyPlot

function Paccept(c,c_prime,T,its)
    if c_prime >= c
        return 1
    else
        return exp(-its)/exp(-1)
    end
end

function main()
    args = parse_commandline()
    n = args["vertices"]
    e = args["edges"]

    if args["simple_graph"]
        args["out_folder"] = string(args["out_folder"], "_sg")
        g = simple_NE_sgraph(n,e)
    else
        g = simple_NE_graph(n,e)
    end

    if !args["no_graph_dot"]
        write_to_file(g,args["out_folder"],args["init_fname"])
    end
    if args["plot_graphs"]
        plot(g)
    end
    if args["save_graphs_plot"]
        plot_to_file(g,args["out_folder"],args["init_fname"])
    end

    current_state = deepcopy(g)
    tot_its = args["iterations"]
    edge_change_prob = args["edge_rewire"]
    T = args["temperature"]
    c = AlgConnectivity(current_state)
    @printf("Original connectivity: %.3f\n",c)
    c_hist = zeros(tot_its,1)
    for i = 1:tot_its
        c_hist[i] = c
        if mod(i,10000) == 0
            @printf("iteration %d\n",i)
        end
        candidate = rewire(deepcopy(current_state),edge_change_prob)
        c_prime = AlgConnectivity(candidate)
            # @printf("Paccept: %0.3f\n",Paccept(c,c_prime,T))
        accept_p = Paccept(c,c_prime,T,tot_its)
        if rand() < accept_p
            # better, lets move there
            c = c_prime
            current_state = deepcopy(candidate)
        else
            continue
        end
    end
    @printf("Final connectivity: %.3f\n",c)
    if !args["no_graph_dot"]
        write_to_file(current_state,args["out_folder"],args["final_fname"])
    end
    if args["plot_graphs"]
        plot(current_state)
    end
    if args["save_graphs_plot"]
        plot_to_file(current_state,args["out_folder"],args["final_fname"])
    end

    if !args["no_chist"]
        PyPlot.plot(collect(1:tot_its),c_hist)
        fname = joinpath(args["out_folder"],args["c_hist_fname"])
        savefig(fname)
    end
end

@time main()
