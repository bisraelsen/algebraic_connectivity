using Graphs
using SimpleGraphs
using PyPlot

function plot_deg_hist(g::GenericGraph, out_fldr::ASCIIString,fname::ASCIIString,ac::Float64)
    # degree histogram
    deglst = zeros(num_vertices(g))
    for i in vertices(g)
        deglst[i] = out_degree(i,g)
    end
    plt_deg_hist(deglst,out_fldr,fname,ac)
end

function plot_deg_hist(g::SimpleGraphs.SimpleGraph, out_fldr::ASCIIString,fname::ASCIIString,ac::Float64)
    deglst = zeros(NV(g))
    v_lst = vlist(g)
    for i=1:NV(g)
        deglst[i] = deg(g,v_lst[i])
    end
    # deglst = deg_hist(g)
    plt_deg_hist(deglst,out_fldr,fname,ac)
end

function plot_deg_list(g::SimpleGraphs.SimpleGraph, out_fldr::ASCIIString,fname::ASCIIString,ac::Float64)
    # degree histogram
    deglst = deg(g)
    plt_deg_hist(deglst,out_fldr,fname,ac)
end

function plt_deg_hist(deglst::Array{},out_fldr::ASCIIString,fname::ASCIIString,ac::Float64)
    mu = mean(deglst)
    sig = std(deglst)
    PyPlot.clf()
    plt[:hist](deglst,maximum(deglst),normed=1,alpha=0.75,facecolor="green")
    PyPlot.axvline(mu,color="k",ls="dashed")
    PyPlot.axvline(mu-sig,color="r",ls="dotted")
    PyPlot.axvline(mu+sig,color="r",ls="dotted")
    title("Degree Distribution")
    xlabel("Degree")
    ylabel("Proportion")
    annotate(@sprintf("a(G)=%0.3f",ac),xy=(0.7,0.8),fontsize=20,xycoords="axes fraction")
    annotate(@sprintf("mu=%0.3f",mu),xy=(0.7,0.7),fontsize=20,xycoords="axes fraction")
    annotate(@sprintf("std=%0.3f",sig),xy=(0.7,0.6),fontsize=20,xycoords="axes fraction")
    fname = joinpath(out_fldr,fname)
    fname = string(fname,".pdf")
    savefig(fname)
end

function plot_c_hist(c_hist::Array{},out_fldr::ASCIIString,fname::ASCIIString)
    # connectivity history
    PyPlot.clf()
    PyPlot.plot(collect(1:length(c_hist)),c_hist)
    title("Connectivity History")
    xlabel("Iteration")
    ylabel("Algebraic Connectivity")
    fname = joinpath(out_fldr,fname)
    fname = string(fname,".pdf")
    savefig(fname)
    clf()
end

function plot_c_box(c_vals::Array{},n::Int,c_opt::Float64,out_fldr::ASCIIString,fname::ASCIIString)
    # connectivity distribution vs. optimal
    PyPlot.clf()
    boxplot(c_vals)
    PyPlot.boxplot(c_vals)
    PyPlot.axhline(c_opt,color="r",ls="dotted")
    title("Optimization Performance")
    # xlabel("n")
    xticks([1,2],["Opt","Random"])
    ylabel("Algebraic Connectivity")
    fname = joinpath(out_fldr,fname)
    fname = string(fname,".pdf")
    savefig(fname)
end
