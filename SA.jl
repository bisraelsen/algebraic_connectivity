module SA
using PyPlot
using ProgressMeter
import JSON
include("random_rewire.jl")
include("utilities.jl")
include("algConnectivity.jl")
include("arg_config.jl")
include("plotting.jl")

export optimize

function Paccept(c,c_prime,T,its,maxits)
    if c_prime >= c
        return 1
    else
        normalizedP = exp(-its/(maxits/8))
        return normalizedP/(c-c_prime)
    end
end

function optimize(ARGS="")
    args = parse_commandline(ARGS)
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
    if !args["no_figs"]
        plot_deg_hist(g,out_fldr,"d_hist_initial")
    end
    save_json(args,out_fldr,"args.txt")
    current_state = deepcopy(g)
    tot_its = args["iterations"]
    edge_change_prob = args["edge_rewire"]
    T = args["temperature"]
    c = AlgConnectivity(current_state,args["sparse_rep"])
    if !args["no_console_output"]
        @printf("Original connectivity: %.3f\n",c)
    end
    if !args["no_figs"]
        plot_deg_hist(g,out_fldr,"d_hist_initial",c)
    end
    c_hist = zeros(tot_its,1)

    p = Progress(tot_its, 30, "Progress: ", 50)
    tic()
    for i = 1:tot_its
        update!(p,i)
        c_hist[i] = c
        candidate = rewire(deepcopy(current_state),edge_change_prob)
        c_prime = AlgConnectivity(candidate,args["sparse_rep"])
        accept_p = Paccept(c,c_prime,T,i,tot_its)

        if rand() < accept_p
            # Moving here
            c = c_prime
            current_state = deepcopy(candidate)
        else
            continue
        end
    end
    t = toq()
    if !args["no_console_output"]
        @printf("Final connectivity: %.3f\n",c)
    end
    if !args["no_graph_dot"]
        write_to_file(current_state,out_fldr,args["final_fname"])
    end
    if args["plot_graphs"]
        plot(current_state)
    end
    if args["save_graphs_plot"]
        plot_to_file(current_state,out_fldr,args["final_fname"])
    end

    if !args["no_figs"]
        plot_c_hist(c_hist,out_fldr,"c_hist")

        plot_deg_hist(current_state,out_fldr,"d_hist_final",c)
    end
    return t
end
end
