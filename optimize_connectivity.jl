include("random_rewire.jl")
include("utilities.jl")
include("algConnectivity.jl")
include("arg_config.jl")
using PyPlot
using ProgressMeter

function Paccept(c,c_prime,T,its)
    if c_prime >= c
        return 1
    else
        normalizedP = exp(-its)/exp(-1)
        return normalizedP/(c-c_prime)
    end
end

function main()
    args = parse_commandline()
    n = args["vertices"]
    e = args["edges"]
    if args["out_folder"] == ""
        dt = replace(string(now()),"T","_")
        dt = replace(dt,":","_")
        dt = replace(dt,"-","_")
        out_fldr = string("res_",dt)
    else
        out_fldr = args["out_folder"]
    end

    if args["simple_graph"]
        out_fldr = string(out_fldr, "_sg")
        g = simple_NE_sgraph(n,e)
    else
        g = simple_NE_graph(n,e)
    end

    if !args["no_graph_dot"]
        write_to_file(g,out_fldr,args["init_fname"])
    end
    if args["plot_graphs"]
        plot(g)
    end
    if args["save_graphs_plot"]
        plot_to_file(g,out_fldr,args["init_fname"])
    end

    current_state = deepcopy(g)
    tot_its = args["iterations"]
    edge_change_prob = args["edge_rewire"]
    T = args["temperature"]
    c = AlgConnectivity(current_state,args["sparse_rep"])
    @printf("Original connectivity: %.3f\n",c)
    c_hist = zeros(tot_its,1)
    p = Progress(tot_its, 30, "Progress: ", 50)
    for i = 1:tot_its
        update!(p,i)
        c_hist[i] = c
        candidate = rewire(deepcopy(current_state),edge_change_prob)
        c_prime = AlgConnectivity(candidate,args["sparse_rep"])
        accept_p = Paccept(c,c_prime,T,tot_its)
        if rand() < accept_p
            # Moving here
            c = c_prime
            current_state = deepcopy(candidate)
        else
            continue
        end
    end
    @printf("Final connectivity: %.3f\n",c)
    if !args["no_graph_dot"]
        write_to_file(current_state,out_fldr,args["final_fname"])
    end
    if args["plot_graphs"]
        plot(current_state)
    end
    if args["save_graphs_plot"]
        plot_to_file(current_state,out_fldr,args["final_fname"])
    end

    if !args["no_chist"]
        PyPlot.plot(collect(1:tot_its),c_hist)
        fname = joinpath(out_fldr,args["c_hist_fname"])
        savefig(fname)
    end
end

@time main()
