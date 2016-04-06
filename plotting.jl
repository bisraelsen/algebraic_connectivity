function plot_deg_hist(g::GenericGraph, out_fldr::ASCIIString,fname::ASCIIString)
    # degree histogram
    deglst = zeros(num_vertices(g))
    for i in vertices(g)
        deglst[i] = out_degree(i,g)
    end
    plt_deg_hist(deglst,out_fldr,fname)
end

function plot_deg_hist(g::SimpleGraphs.SimpleGraph, out_fldr::ASCIIString,fname::ASCIIString)
    deglst = zeros(NV(g))
    v_lst = vlist(g)
    for i=1:NV(g)
        deglst[i] = deg(g,v_lst[i])
    end
    # deglst = deg_hist(g)
    plt_deg_hist(deglst,out_fldr,fname)
end

function plot_deg_list(g::SimpleGraphs.SimpleGraph, out_fldr::ASCIIString,fname::ASCIIString)
    # degree histogram
    deglst = deg(g)
    plt_deg_hist(deglst,out_fldr,fname)
end

function plt_deg_hist(deglst::Array{},out_fldr::ASCIIString,fname::ASCIIString)
    plt[:hist](deglst,maximum(deglst),normed=1,alpha=0.75,facecolor="green")
    title("Degree Distribution")
    xlabel("Degree")
    ylabel("Proportion")
    fname = joinpath(out_fldr,fname)
    fname = string(fname,".pdf")
    savefig(fname)
end

function plot_c_hist(c_hist::Array{},out_fldr::ASCIIString,fname::ASCIIString)
    # connectivity history
    PyPlot.plot(collect(1:length(c_hist)),c_hist)
    title("Connectivity History")
    xlabel("Iteration")
    ylabel("Algebraic Connectivity")
    fname = joinpath(out_fldr,fname)
    fname = string(fname,".pdf")
    savefig(fname)
    clf()
end
