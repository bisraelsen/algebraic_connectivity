using ArgParse

function gt0(x)
    if x> 0
        return true
    else
        return false
    end
end

function leq1gt0(x)
    if x <= 1 && x > 0
        return true
    else
        return false
    end
end

function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table s begin
        ## Parameters
        "--vertices", "-n"
            help = "Total number of vertices"
            arg_type = Int
            default = 10
            range_tester = gt0
        "--edges", "-e"
            help = "Total number of edges"
            arg_type = Int
            default = 9
            range_tester = gt0
        "--iterations", "-i"
            help = "Total number of iterations"
            arg_type = Int
            default = 5000
            range_tester = gt0
        "--edge_rewire", "-r"
            help = "Percent of edges to be rewired"
            arg_type = Float64
            default = 0.75
            range_tester = leq1gt0
        "--temperature", "-t"
            help = "Annealing temperature"
            arg_type = Float64
            default = 1.0

        ## Output config
        "--out_folder"
            help = "name of the folder in which to store output"
            arg_type = AbstractString
            default = "results"
        "--init_fname"
            help = "name for the .dot or .png of the original graph to be saved as"
            arg_type = AbstractString
            default = "initial"
        "--final_fname"
            help = "name for the .dot or .png of the final graph to be saved as"
            arg_type = AbstractString
            default = "final"
        "--c_hist_fname"
            help = "file name and type for the connectivity history to be output as ex. 'c_hist.pdf' or 'c_hist.svg'"
            arg_type = AbstractString
            default = "c_hist.pdf"
        "--no_chist"
            help = "Don't save connectivity plot to history"
            action = :store_true
        "--plot_graphs"
            help = "Produce GraphViz plots of graphs"
            action = :store_true
        "--save_graphs_plot"
            help = "Produce GraphViz plots of graphs"
            action = :store_true
        "--no_graph_dot"
            help = "Don't write graphs to .dot file"
            action = :store_true
    end

    return parse_args(s)
end
