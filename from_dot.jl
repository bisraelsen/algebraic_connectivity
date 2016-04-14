include("plotting.jl")
include("algConnectivity.jl")
out_fldr = "projectResults/empirical_results_sg/"
fnames = ["initial","final"]

for fname in fnames
    f = open(string(joinpath(out_fldr,fname),".dot"),"r")

    g = SimpleGraphs.SimpleGraph()

    for i in enumerate(eachline(f))
        if i[1] == 1 || eof(f)
            continue
        else
            inew = [parse(Int,x) for x in split(i[2],"--")]
            if length(inew) == 1
                add!(g,inew[1])
            else
                add!(g,inew[1],inew[2])
            end
        end
    end
    close(f)
    clf()
    ac = AlgConnectivity(g,false)
    plot_deg_hist(g,out_fldr,string("d_hist_",fname),ac)
end
